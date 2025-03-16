require 'minitest/autorun'
require_relative '../vehicle'

class VehicleTest < Minitest::Test
  def setup
    # Reset the vehicle count for testing
    Vehicle.class_variable_set(:@@number_of_vehicles, 0)
  end

  def test_creation_and_tracking
    vehicle = Vehicle.new(2020, 'Generic Model', 'Silver')
    assert_equal 2020, vehicle.year
    assert_equal 'Generic Model', vehicle.model
    assert_equal 'Silver', vehicle.color
    assert_equal 0, vehicle.current_speed

    # Test the vehicle counter
    assert_equal 1, Vehicle.class_variable_get(:@@number_of_vehicles)
    Vehicle.new(2021, 'Another Model', 'Black')
    assert_equal 2, Vehicle.class_variable_get(:@@number_of_vehicles)
  end

  def test_speed_methods
    vehicle = Vehicle.new(2020, 'Test Model', 'Red')

    assert_output(/You accelerated 20 mph./) { vehicle.speed_up(20) }
    assert_equal 20, vehicle.current_speed

    assert_output(/You are now going 20 mph./) { vehicle.current_speed }

    assert_output(/You decelerated 10 mph./) { vehicle.brake(10) }
    assert_equal 10, vehicle.current_speed

    assert_output(/Let's park the vehicle!/) { vehicle.shut_down }
    assert_equal 0, vehicle.current_speed
  end

  def test_spray_paint
    vehicle = Vehicle.new(2020, 'Test Model', 'Blue')
    assert_output(/Your new Yellow paint job looks great!/) { vehicle.spray_paint("Yellow") }
    assert_equal "Yellow", vehicle.color
  end

  def test_gas_mileage
    assert_output("Your gas mileage is 27 miles per gallon.\n") { Vehicle.gas_mileage(350, 13) }
  end

  def test_to_s
    vehicle = MyCar.new(2019, 'Test Model', 'Green')
    assert_equal "My car is a Green 2019 Test Model!", vehicle.to_s
  end
end

class MyCarTest < Minitest::Test
  def setup
    @car = MyCar.new(1997, 'chevy lumina', 'white')
  end

  def test_inheritance
    assert_kind_of Vehicle, @car
  end

  def test_constants
    assert_equal 4, MyCar::NUMBER_OF_DOORS
  end

  def test_to_s
    assert_equal "My car is a white, 1997, chevy lumina!", @car.to_s
  end

  def test_shut_down
    assert_output(/Let's park the car!/) { @car.shut_down }
  end

  def test_towable
    assert @car.can_tow?(1000)
    refute @car.can_tow?(3000)
  end

  def test_stability_control
    assert_output(/Activating towing stability control/) { @car.stability_control }
  end

  def test_sample_sequence
    car = MyCar.new(1997, 'chevy lumina', 'white')

    assert_output(/You accelerated 20 mph./) { car.speed_up(20) }
    assert_output(/You are now going 20 mph./) { car.current_speed }
    assert_output(/You accelerated 20 mph./) { car.speed_up(20) }
    assert_output(/You are now going 40 mph./) { car.current_speed }
    assert_equal "My car is a white, 1997, chevy lumina!", car.to_s
    assert_output(/You decelerated 20 mph./) { car.brake(20) }
    assert_output(/You are now going 20 mph./) { car.current_speed }
    assert_output(/You decelerated 20 mph./) { car.brake(20) }
    assert_output(/You are now going 0 mph./) { car.current_speed }
    assert_output(/Let's park the car!/) { car.shut_down }
  end
end

class MyTruckTest < Minitest::Test
  def setup
    @truck = MyTruck.new(1990, 'GMC', 'black')
  end

  def test_inheritance
    assert_kind_of Vehicle, @truck
  end

  def test_constants
    assert_equal 2, MyTruck::NUMBER_OF_DOORS
  end

  def test_to_s
    assert_equal "My truck is a black, 1990, GMC!", @truck.to_s
  end

  def test_shut_down
    assert_output(/Let's park the truck!/) { @truck.shut_down }
  end

  def test_towable
    assert @truck.can_tow?(1000)
    refute @truck.can_tow?(3000)
  end
end

class ElectricCarTest < Minitest::Test
  def setup
    @tesla = ElectricCar.new(2021, 'Tesla Plaid', 'blue', 80)
  end

  def test_inheritance
    assert_kind_of MyCar, @tesla
    assert_kind_of Vehicle, @tesla
  end

  def test_to_s
    assert_equal "My car is a blue, 2021, Tesla Plaid!", @tesla.to_s
  end

  def test_battery_initialization
    # Test default value
    default_car = ElectricCar.new(2022, 'Model 3', 'red')
    assert_equal 100, default_car.battery_charge

    # Test provided value
    assert_equal 80, @tesla.battery_charge

    # Test value limits
    over_car = ElectricCar.new(2022, 'Model S', 'black', 120)
    assert_equal 100, over_car.battery_charge

    under_car = ElectricCar.new(2022, 'Model X', 'white', -10)
    assert_equal 0, under_car.battery_charge
  end

  def test_current_battery
    assert_output(/Current battery charge: 80%/) { @tesla.current_battery }
  end

  def test_charge_battery
    @tesla.battery_charge = 40
    assert_output(/Battery fully charged./) { @tesla.charge_battery }
    assert_equal 100, @tesla.battery_charge
  end

  def test_speed_up_with_battery
    expected_output = "You accelerated 20 mph.\nBattery decreased by 10%."
    assert_output(/#{expected_output}/) { @tesla.speed_up(20) }
    assert_equal 20, @tesla.current_speed
    assert_equal 70, @tesla.battery_charge

    # Test low battery case
    low_tesla = ElectricCar.new(2021, 'Model Y', 'gray', 5)
    assert_output(/Error: Battery charge is too low/) { low_tesla.speed_up(10) }
  end

  def test_shut_down_scenarios
    # No autopilot used
    new_tesla = ElectricCar.new(2021, 'Model 3', 'blue')
    expected_output = "Shutting down the battery-powered motor!\nLet's park the car!"
    assert_output(/#{expected_output}/) { new_tesla.shut_down }

    # Autopilot engaged
    engaged_tesla = ElectricCar.new(2021, 'Model S', 'red')
    assert_output(/Autopilot engaged./) { engaged_tesla.engage_autopilot }

    expected_output = "Disengaging and terminating self-driving services!\nShutting down the battery-powered motor!\nLet's park the car!"
    assert_output(/#{expected_output}/) { engaged_tesla.shut_down }

    # Autopilot used but disengaged
    disengaged_tesla = ElectricCar.new(2021, 'Model X', 'black')
    disengaged_tesla.engage_autopilot
    disengaged_tesla.disengage_autopilot

    expected_output = "Terminating self-driving services!\nShutting down the battery-powered motor!\nLet's park the car!"
    assert_output(/#{expected_output}/) { disengaged_tesla.shut_down }
  end

  def test_autopilot
    refute @tesla.autopilot
    assert_output(/Autopilot engaged./) { @tesla.engage_autopilot }
    assert @tesla.autopilot
    @tesla.disengage_autopilot
    refute @tesla.autopilot
  end

  def test_stability_control_priority
    # Should use Towable's version, not SelfDriving's
    assert_output(/Activating towing stability control/) { @tesla.stability_control }
  end

  def test_can_tow
    assert @tesla.can_tow?(1500)
    refute @tesla.can_tow?(3000)
  end

  def test_sample_sequence
    tesla = ElectricCar.new(2021, 'Tesla Plaid', 'blue', 80)

    assert_output(/Current battery charge: 80%/) { tesla.current_battery }

    expected_output = "You accelerated 30 mph.\nBattery decreased by 10%."
    assert_output(/#{expected_output}/) { tesla.speed_up(30) }

    assert_output(/You are now going 30 mph./) { tesla.current_speed }
    assert_output(/Current battery charge: 70%/) { tesla.current_battery }

    expected_output = "You accelerated 30 mph.\nBattery decreased by 10%."
    assert_output(/#{expected_output}/) { tesla.speed_up(30) }

    assert_output(/You decelerated 20 mph./) { tesla.brake(20) }
    assert_output(/You are now going 40 mph./) { tesla.current_speed }
    assert_output(/Current battery charge: 60%/) { tesla.current_battery }

    assert_output(/Battery fully charged./) { tesla.charge_battery }
    assert_output(/Current battery charge: 100%/) { tesla.current_battery }

    assert_output(/Autopilot engaged./) { tesla.engage_autopilot }

    expected_output = "You accelerated 100 mph.\nBattery decreased by 10%."
    assert_output(/#{expected_output}/) { tesla.speed_up(100) }

    expected_output = "Disengaging and terminating self-driving services!\nShutting down the battery-powered motor!\nLet's park the car!"
    assert_output(/#{expected_output}/) { tesla.shut_down }
  end

  def test_full_scenarios
    # Test a complete usage scenario similar to the sample code
    Vehicle.class_variable_set(:@@number_of_vehicles, 0)

    lumina = MyCar.new(1997, 'chevy lumina', 'white')
    ram = MyTruck.new(1990, 'GMC', "black")
    tesla = ElectricCar.new(2021, 'Tesla Plaid', "blue", 80)

    assert_equal "My car is a white, 1997, chevy lumina!", lumina.to_s
    assert_equal "My truck is a black, 1990, GMC!", ram.to_s
    assert_equal "My car is a blue, 2021, Tesla Plaid!", tesla.to_s

    assert ram.can_tow?(1000)
    refute lumina.can_tow?(3000)
    assert tesla.can_tow?(1500)

    assert_output(/Activating towing stability control/) { lumina.stability_control }
    assert_output(/Activating towing stability control/) { tesla.stability_control }

    assert_equal 3, Vehicle.class_variable_get(:@@number_of_vehicles)
  end
end
