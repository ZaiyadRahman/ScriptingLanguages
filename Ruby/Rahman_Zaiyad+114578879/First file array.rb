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

  def map(sequence = nil,
          &block)
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