#!/bin/bash

# Ensure exactly one input (the data file) is provided
if [ "$#" -ne 1 ]; then
    echo "missing data file"
    exit 1
fi

input_file="$1"

# Check if the input file exists; if not, display an error message.
if [ ! -f "$input_file" ]; then
    echo "File not found: $input_file"
    exit 1
fi

total_cost=0

# Process the file line by line
while IFS= read -r line; do
    # Skip the header line
    if [[ "$line" == *"Title"* && "$line" == *"Price"* && "$line" == *"Quantity"* ]]; then
        continue
    fi

    # Extract the price and quantity
    price=$(echo "$line" | cut -d, -f2 | tr -d ' ')
    quantity=$(echo "$line" | cut -d, -f3 | tr -d ' ')

    total_cost=$(( total_cost + price * quantity ))
done < "$input_file"

# Determine the discount rate based on total cost thresholds.
if [ "$total_cost" -ge 500 ]; then
    discount_rate=15
elif [ "$total_cost" -ge 201 ]; then
    discount_rate=10
elif [ "$total_cost" -ge 100 ]; then
    discount_rate=5
else
    discount_rate=0
fi

discount=$(( total_cost * discount_rate / 100 ))
final_cost=$(( total_cost - discount ))

echo "$final_cost"

exit 0
