#!/bin/bash

# Check if both source and destination directories are provided
if [ "$#" -ne 2 ]; then
    echo "src and dest dirs missing"
    exit 1
fi

# Store command-line arguments
src_dir="$1"
dest_dir="$2"

# Check if source directory exists
if [ ! -d "$src_dir" ]; then
    echo "$src_dir not found."
    exit 0
fi

# Create destination directory if it doesn't exist
if [ ! -d "$dest_dir" ]; then
    mkdir -p "$dest_dir"
fi

# Process each directory
find "$src_dir" -type d | while IFS= read -r dir; do
    # Get relative path from source directory
    rel_path="${dir#"$src_dir"}"
    rel_path="${rel_path#/}"  # Remove leading slash if present

    # Determine destination directory
    dest_subdir="$dest_dir"
    if [ -n "$rel_path" ]; then
        dest_subdir="$dest_dir/$rel_path"
        # Create destination subdirectory
        mkdir -p "$dest_subdir"
    fi

    # Count all files in the directory
    file_count=0
    for file in "$dir"/*; do
        if [ -f "$file" ]; then
            ((file_count++))
        fi
    done

    # Skip if no files in this directory
    if [ $file_count -eq 0 ]; then
        continue
    fi

    # Handle directories with 5 or more files
    if [ $file_count -ge 5 ]; then
        echo "Directory $dir has 5 or more files:"
        for file in "$dir"/*; do
            if [ -f "$file" ]; then
                echo "  $(basename "$file")"
            fi
        done

        # Ask for confirmation using -r flag to handle backslashes correctly
        read -r -p "Do you want to move these files? (y/n): " confirm
        if [[ ! "$confirm" =~ [yY] ]]; then
            echo "Skipping files in $dir"
            continue
        fi
    fi

    # Move all files
    for file in "$dir"/*; do
        if [ -f "$file" ]; then
            mv "$file" "$dest_subdir/"
        fi
    done
done

exit 0
