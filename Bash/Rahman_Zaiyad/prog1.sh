#!/bin/bash

# Check if both source and destination directories are provided
if [ "$#" -ne 2 ]; then
    echo "src and dest dirs missing"
    exit 1
fi


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

find "$src_dir" -type d | while IFS= read -r dir; do
    rel_path="${dir#"$src_dir"}"
    rel_path="${rel_path#/}"

    # Determine destination directory
    dest_subdir="$dest_dir"
    if [ -n "$rel_path" ]; then
        dest_subdir="$dest_dir/$rel_path"
        mkdir -p "$dest_subdir"
    fi

    file_count=0
    for file in "$dir"/*; do
        if [ -f "$file" ]; then
            ((file_count++))
        fi
    done

    if [ $file_count -eq 0 ]; then
        continue
    fi

    # Flag to track whether to move files
    move_files=true

    # Handle directories with 5 or more files
    if [ $file_count -ge 5 ]; then
        echo "Directory $dir has 5 or more files:"
        for file in "$dir"/*; do
            if [ -f "$file" ]; then
                echo "  $(basename "$file")"
            fi
        done

        # Ask for confirmation
          echo -n "Do you want to move these files? (y/n): "
          read -r confirm </dev/tty

        # If user says anything but y or Y, do not move
        if [[ ! "$confirm" =~ [yY] ]]; then
            move_files=false
        fi
    fi

    # Move logic
    if [ "$move_files" = true ]; then
        for file in "$dir"/*; do
            if [ -f "$file" ]; then
                mv "$file" "$dest_subdir/"
            fi
        done
    fi
done


exit 0
