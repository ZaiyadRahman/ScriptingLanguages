def find_encryption(integers)
  raise ArgumentError, "Input must be an array with at least two elements" if integers.length < 2
  while integers.length > 2
    new_nums = []
    # enumerates through the list of integers and sums each pair of adjacent integers, taking the rightmost digit, adds it to new_nums
    (0...integers.length - 1).each do |i|
      sum = (integers[i] + integers[i + 1]) % 10
      new_nums << sum
    end
    # replaces the original integers with the new array of summed integers. The process repeats until only two integers remain and gets printed
    integers = new_nums
  end
  integers.join
end

# Test cases
puts find_encryption([3, 7, 2, 4])          # Expected: "95"
puts find_encryption([4, 2])                # Expected: "42"
puts find_encryption([1, 0, 5])             # Expected: "15"
puts find_encryption([15, 25, 35])          # Expected: "00"
puts find_encryption([0, 1, 0, 3])          # Expected: "24"
puts find_encryption([1, 2, 3, 4, 5, 6, 7, 8, 9])  # Expected: "64"
puts find_encryption([5, 5, 5, 5, 5])       # Expected: "00"

# Edge cases where input is invalid
begin
  puts find_encryption([])                  # Expected: ArgumentError
rescue ArgumentError => e
  puts "Empty array error: #{e.message}"
end

begin
  puts find_encryption([7])                 # Expected: ArgumentError
rescue ArgumentError => e
  puts "Single digit error: #{e.message}"
end