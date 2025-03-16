require 'minitest/autorun'
require_relative '../pascal_triangle.rb'

class EncryptionTest < Minitest::Test
  def test_example_case
    # Test the example provided in the problem statement
    assert_equal "95", find_encryption([3, 7, 2, 4])
  end

  def test_two_digits_array
    # When array already has two digits, should return those digits as string
    assert_equal "42", find_encryption([4, 2])
  end

  def test_single_iteration_to_completion
    # Test when only one iteration is needed to get to two digits
    assert_equal "15", find_encryption([1, 0, 5])
  end

  def test_with_larger_numbers
    # Ensure it correctly handles numbers > 9 by only taking rightmost digit
    assert_equal "00", find_encryption([15, 25, 35])
  end

  def test_with_zeros
    # Test handling arrays containing zeros
    assert_equal "24", find_encryption([0, 1, 0, 3])
  end

  def test_long_array
    # Test with a longer array of digits
    assert_equal "64", find_encryption([1, 2, 3, 4, 5, 6, 7, 8, 9])
  end

  def test_repeated_digits
    # Test with repeated digits
    assert_equal "00", find_encryption([5, 5, 5, 5, 5])
  end

  def test_edge_case_empty_array
    # Test handling empty arrays - should raise an error
    assert_raises(ArgumentError) { find_encryption([]) }
  end

  def test_edge_case_single_digit
    # Test handling single digit arrays - should raise an error
    assert_raises(ArgumentError) { find_encryption([7]) }
  end

  def test_step_by_step_verification
    # This test verifies each intermediate step of the algorithm
    input = [3, 7, 2, 4]

    # First iteration should produce [0, 9, 6]
    first_iteration = perform_one_iteration(input)
    assert_equal [0, 9, 6], first_iteration

    # Second iteration should produce [9, 5]
    second_iteration = perform_one_iteration(first_iteration)
    assert_equal [9, 5], second_iteration

    # Final result should be "95"
    assert_equal "95", find_encryption(input)
  end

  # Helper method to perform one iteration of the algorithm
  # This isn't necessary for the actual implementation but helps with testing
  def perform_one_iteration(numbers)
    result = []
    (0...numbers.length - 1).each do |i|
      sum = numbers[i] + numbers[i + 1]
      result << sum % 10
    end
    result
  end
end
