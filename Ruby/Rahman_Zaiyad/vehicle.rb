module Towable
  def can_tow?(lbs)
    lbs < 2000
  end

  def stability_control
    puts "Activating towing stability control for hauling…"
  end
end

module SelfDriving
  attr_accessor :autopilot

  def engage_autopilot
    self.autopilot = true
    @autopilot_used = true
  end

  def disengage_autopilot
    self.autopilot = false
  end

  def stability_control
    puts "Activating lane-centering stability control for autopilot…"
  end
end

class Vehicle
  @@number_of_vehicles = 0
  attr_accessor :year, :model, :color, :current_speed

  def initialize(year, model, color)
    @year = year
    @model = model
    @color = color
    @current_speed = 0
    @@number_of_vehicles += 1
  end

  def self.number_of_vehicles
    puts "Number of vehicles: #{@@number_of_vehicles}"
  end

  def speed_up(increment)
    @current_speed += increment
    puts "You accelerated #{increment} mph."
  end

  def brake(decrement)
    @current_speed -= decrement
    if @current_speed < 0
      @current_speed = 0
    end
    puts "You decelerated #{decrement} mph."
  end

  def current_speed
    puts "You are now going #{@current_speed} mph."
    @current_speed
  end

  def shut_down
    @current_speed = 0
    puts "Let's park the vehicle!"
  end

  def spray_paint(color)
    self.color = color
    puts "Your new #{color} paint job looks great!"
  end

  def self.gas_mileage(miles, gallons)
    mileage = (miles / gallons.to_f).round
    puts "Your gas mileage is #{mileage} miles per gallon."
    mileage
  end
end

class MyCar < Vehicle
  NUMBER_OF_DOORS = 4
  include Towable

  def shut_down
    @current_speed = 0
    puts "Let's park the car!"
  end

  def to_s
    "My car is a #{@color} #{@year} #{@model}!"
  end
end

class MyTruck < Vehicle
  NUMBER_OF_DOORS = 2
  include Towable

  def shut_down
    @current_speed = 0
    puts "Let's park the truck!"
  end

  def to_s
    "My truck is a #{@color} #{@year} #{@model}!"
  end
end

class ElectricCar < MyCar
  include SelfDriving
  include Towable
  attr_accessor :battery_charge
  def initialize(year, model, color, battery_charge = 100)
    super(year, model, color)
    @battery_charge = [[battery_charge, 100].min, 0].max # Keeps battery between 0-100
    @autopilot = false
    @autopilot_used = false
  end

  def speed_up(increment)
    if @battery_charge <= 0 || @battery_charge - 10 < 0
      puts "Error: Not enough battery charge to accelerate."
      return
    end
    super(increment) # Use parent class to speed up
    @battery_charge -= 10 # Decrease battery charge with each acceleration
    puts "Battery charge: #{@battery_charge}%."
  end

  def current_battery
    puts "Current battery charge: #{@battery_charge}%."
  end

  def charge_battery
      @battery_charge = 100
      puts "Battery fully charged!"
    end

def shut_down
    @current_speed = 0
    if !@autopilot_used
      puts "Shutting down the battery-powered motor!\nLet's park the car!"

    elsif @autopilot
      disengage_autopilot
      puts "Disengaging and terminating self-driving services!\nShutting down the battery-powered motor!\nLet’s park the car!"
    else
      puts "Terminating self-driving services!\nShutting down the battery-powered motor!\nLet's park the car!"
    end
end
end

