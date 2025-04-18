#!/bin/bash

# Check if the score directory is provided as the only argument.
if [ "$#" -ne 1 ]; then
    echo "score directory missing"
    exit 1
fi

score_dir="$1"

# Verify that the given argument is a valid directory.
if [ ! -d "$score_dir" ]; then
    echo "$score_dir is not a directory"
    exit 1
fi

# Process each .txt file in the score directory.
for file in "$score_dir"/*.txt; do
    if [ -f "$file" ]; then
        # Extract the student ID and scores from the file, ignoring spaces
        id=$(grep "^ID," "$file" | cut -d',' -f2 | tr -d ' ')
        q1=$(grep "^ID," "$file" | cut -d',' -f3 | tr -d ' ')
        q2=$(grep "^ID," "$file" | cut -d',' -f4 | tr -d ' ')
        q3=$(grep "^ID," "$file" | cut -d',' -f5 | tr -d ' ')
        q4=$(grep "^ID," "$file" | cut -d',' -f6 | tr -d ' ')
        q5=$(grep "^ID," "$file" | cut -d',' -f7 | tr -d ' ')

        # Calculate the total score and convert it to percentage.
        total=$(( q1 + q2 + q3 + q4 + q5 ))
        percentage=$(( total * 100 / 50 ))

        # Determine the corresponding letter grade.
        if [ "$percentage" -ge 93 ]; then
            grade="A"
        elif [ "$percentage" -ge 80 ]; then
            grade="B"
        elif [ "$percentage" -ge 65 ]; then
            grade="C"
        else
            grade="D"
        fi

        # Display the student ID and letter grade.
        echo "$id:$grade"
    fi
done

exit 0
