class Array
  alias_method :original_bracket, :[]
  alias_method :original_map, :map

  def [](index)
    if index < -self.length || index >= self.length
      '\0'  # Return '\0' for out-of-bounds indices
    else
      original_bracket(index)  # Use the original method for in-bounds indices
    end
  end

  def map(sequence = nil, &block)
    return original_map(&block) if sequence.nil?  # Default to original behavior if no step provided

    if sequence.is_a?(Range)
      # Handle case where step is a range (like 2..4)
      result = []
      # Select only valid indices from the range
      valid_indices = sequence.to_a.select { |i| i >= -self.length && i < self.length }
      # Apply the block to elements at those indices
      valid_indices.each do |i|
        result << block.call(self[i])
      end
      result
    elsif sequence <= 0
      # Return empty array for invalid step value
      return []
    else
      # Original case: step is a positive integer
      result = []
      (0...self.length).step(sequence) do |i|
        result << block.call(self[i])
      end
      result
    end
  end
end

# Test cases:

a = [1,2,34,5]
puts a[1] # 2
puts a[10] # '\0'
p a.map(2..4) { |i| i.to_f} # [34.0, 5.0]
p a.map { |i| i.to_f} # [1.0, 2.0, 34.0, 5.0]

b = ["cat", "bat", "mat", "sat"]
puts b[-1] # "sat"
puts b[5] # '\0'
p b.map(2..10) { |x| x[0].upcase + x[1,x.length] } # ["Mat", "Sat"]
p b.map(2..4) { |x| x[0].upcase + x[1,x.length] } # ["Mat", "Sat"]
p b.map(-3..-1) { |x| x[0].upcase + x[1,x.length] } # ["Bat", "Mat", “Sat”]
p b.map { |x| x[0].upcase + x[1,x.length] } # ["Cat", "Bat", "Mat", "Sat"]

# Test 1: Normal access with positive indices
a1 = [10, 20, 30, 40, 50]
puts "Test 1.1: a1[2] = #{a1[2]} (Expected: 30)"
puts "Test 1.2: a1[0] = #{a1[0]} (Expected: 10)"
puts "Test 1.3: a1[4] = #{a1[4]} (Expected: 50)"

# Test 2: Access with negative indices
puts "Test 2.1: a1[-1] = #{a1[-1]} (Expected: 50)"
puts "Test 2.2: a1[-3] = #{a1[-3]} (Expected: 30)"
puts "Test 2.3: a1[-5] = #{a1[-5]} (Expected: 10)"

# Test 3: Access with out-of-bounds indices
puts "Test 3.1: a1[5] = #{a1[5]} (Expected: '\\0')"
puts "Test 3.2: a1[100] = #{a1[100]} (Expected: '\\0')"
puts "Test 3.3: a1[-6] = #{a1[-6]} (Expected: '\\0')"
puts "Test 3.4: a1[-100] = #{a1[-100]} (Expected: '\\0')"

# Test 4: Edge case - empty array
a2 = []
puts "Test 4.1: a2[0] = #{a2[0]} (Expected: '\\0')"
puts "Test 4.2: a2[-1] = #{a2[-1]} (Expected: '\\0')"

puts "\nModified map method tests:"

# Test 5: Original map behavior (no sequence argument)
a3 = [1, 2, 3, 4, 5]
result5 = a3.map { |x| x * 2 }
puts "Test 5: a3.map { |x| x * 2 } = #{result5} (Expected: [2, 4, 6, 8, 10])"

# Test 6: Map with positive step
result6_1 = a3.map(2) { |x| x * 2 }
puts "Test 6.1: a3.map(2) { |x| x * 2 } = #{result6_1} (Expected: [2, 6, 10])"

result6_2 = a3.map(3) { |x| x * 2 }
puts "Test 6.2: a3.map(3) { |x| x * 2 } = #{result6_2} (Expected: [2, 8])"

# Test 7: Map with non-positive step (should return empty array)
result7_1 = a3.map(0) { |x| x * 2 }
puts "Test 7.1: a3.map(0) { |x| x * 2 } = #{result7_1} (Expected: [])"

result7_2 = a3.map(-1) { |x| x * 2 }
puts "Test 7.2: a3.map(-1) { |x| x * 2 } = #{result7_2} (Expected: [])"

# Test 8: Map with step larger than array (should return just first element)
result8 = a3.map(10) { |x| x * 2 }
puts "Test 8: a3.map(10) { |x| x * 2 } = #{result8} (Expected: [2])"

# Test 9: Map with range having positive indices
letters = ["a", "b", "c", "d", "e"]
result9_1 = letters.map(1..3) { |x| x.upcase }
puts "Test 9.1: letters.map(1..3) { |x| x.upcase } = #{result9_1} (Expected: [\"B\", \"C\", \"D\"])"

# Test 10: Map with range having negative indices
result10 = letters.map(-3..-1) { |x| x.upcase }
puts "Test 10: letters.map(-3..-1) { |x| x.upcase } = #{result10} (Expected: [\"C\", \"D\", \"E\"])"

# Test 11: Map with mixed positive and negative indices in range
result11 = letters.map(-4..2) { |x| x.upcase }
puts "Test 11: letters.map(-4..2) { |x| x.upcase } = #{result11} (Expected: [\"B\", \"C\"])"

# Test 12: Map with partially out-of-bounds range
result12_1 = letters.map(3..7) { |x| x.upcase }
puts "Test 12.1: letters.map(3..7) { |x| x.upcase } = #{result12_1} (Expected: [\"D\", \"E\"])"

result12_2 = letters.map(-10..-4) { |x| x.upcase }
puts "Test 12.2: letters.map(-10..-4) { |x| x.upcase } = #{result12_2} (Expected: [\"A\", \"B\"])"

# Test 13: Map with completely out-of-bounds range
result13 = letters.map(5..10) { |x| x.upcase }
puts "Test 13: letters.map(5..10) { |x| x.upcase } = #{result13} (Expected: [])"

# Test 14: Map with empty array
empty = []
result14 = empty.map(2) { |x| x.to_s }
puts "Test 14: empty.map(2) { |x| x.to_s } = #{result14} (Expected: [])"

# Test 15: Map with single element array
single = [42]
result15_1 = single.map(1) { |x| x * 2 }
puts "Test 15.1: single.map(1) { |x| x * 2 } = #{result15_1} (Expected: [84])"

result15_2 = single.map(2) { |x| x * 2 }
puts "Test 15.2: single.map(2) { |x| x * 2 } = #{result15_2} (Expected: [84])"