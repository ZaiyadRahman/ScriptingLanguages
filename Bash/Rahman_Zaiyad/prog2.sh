#!/bin/bash

# Check if both input and output file paths are provided
if [ "$#" -ne 2 ]; then
    echo "data file or output file not found."
    exit 1
fi

input_file="$1"
output_file="$2"

if [ ! -f "$input_file" ]; then
    echo "$input_file not found"
    exit 1
fi

if grep -qE '[^0-9;:,[:space:]-]' "$input_file"; then
    echo "Illegal Pattern in Input_file."
    exit 1
fi

# Count the maximum number of columns from the data file
max_cols=0
while IFS= read -r line; do
    # Replace all separators with a space
    normalized=$(echo "$line" | tr ';:,' ' ')
    col_count=$(echo "$normalized" | wc -w)
    if [ "$col_count" -gt "$max_cols" ]; then
        max_cols="$col_count"
    fi
done < "$input_file"

# Initialize an array to hold the running column sums
declare -a col_sums
for ((i=1; i<=max_cols; i++)); do
    col_sums[$i]=0
done

# Process each line again and add numbers to the respective column sums
while IFS= read -r line; do
    normalized=$(echo "$line" | tr ';:,' ' ')
    col=1
    for num in $normalized; do
        col_sums[$col]=$(( col_sums[$col] + num ))
        ((col++))
    done
done < "$input_file"

true > "$output_file"
for ((i=1; i<=max_cols; i++)); do
    echo "Col $i: ${col_sums[$i]}" >> "$output_file"
done

exit 0
