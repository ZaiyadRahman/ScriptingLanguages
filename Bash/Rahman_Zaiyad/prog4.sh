#!/bin/bash

# Check if the score directory is provided as the only argument.
if [ "$#" -ne 1 ]; then
    echo "score directory missing"
    exit 1
fi

score_dir="$1"

if [ ! -d "$score_dir" ]; then
    echo "$score_dir is not a directory"
    exit 1
fi

for file in "$score_dir"/*.txt; do
    if [ -f "$file" ]; then
        # Extract the student ID and scores
        id=$(sed -n '2p' "$file" | cut -d',' -f1 | tr -d ' ')
        q1=$(sed -n '2p' "$file" | cut -d',' -f2 | tr -d ' ')
        q2=$(sed -n '2p' "$file" | cut -d',' -f3 | tr -d ' ')
        q3=$(sed -n '2p' "$file" | cut -d',' -f4 | tr -d ' ')
        q4=$(sed -n '2p' "$file" | cut -d',' -f5 | tr -d ' ')
        q5=$(sed -n '2p' "$file" | cut -d',' -f6 | tr -d ' ')

        total=$(( q1 + q2 + q3 + q4 + q5 ))
        percentage=$(( total * 100 / 50 ))

        if [ "$percentage" -ge 93 ]; then
            grade="A"
        elif [ "$percentage" -ge 80 ]; then
            grade="B"
        elif [ "$percentage" -ge 65 ]; then
            grade="C"
        else
            grade="D"
        fi

        echo "$id:$grade"
    fi
done

exit 0
