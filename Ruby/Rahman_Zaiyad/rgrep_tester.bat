@echo off

echo.
echo Test case 1: Missing required arguments
echo Expected: "Missing required arguments"
echo Actual:
ruby rgrep.rb
echo.

echo Test case 2: Word search
echo Expected: Lines containing the whole word "road" (101 broad road, 102 high road)
echo Actual:
ruby rgrep.rb Addresses.txt -w road
echo.

echo Test case 3: Regex search with count
echo Expected: Number of lines containing two-digit numbers (should be 5)
echo Actual:
ruby rgrep.rb Addresses.txt -p -c "\d\d"
echo.

echo Test case 4: Inverted search
echo Expected: Lines that don't contain two-digit numbers (should be 0 lines)
echo Actual:
ruby rgrep.rb Addresses.txt -v "\d\d"
echo.

echo Test case 5: Invalid option
echo Expected: "Invalid option"
echo Actual:
ruby rgrep.rb Addresses.txt -f test
echo.

echo.
echo Test case 6: Default behavior (no options specified)
echo Expected: Lines containing "road" (101 broad road, 101 broad lane, 102 high road)
echo Actual:
ruby rgrep.rb Addresses.txt road
echo.

echo Test case 7: Match display (-m option)
echo Expected: All three-digit numbers (101, 102, 234, 224)
echo Actual:
ruby rgrep.rb Addresses.txt -m "\d\d\d"
echo.

echo Test case 8: Word search with match display
echo Expected: Only the word "road" (printed twice)
echo Actual:
ruby rgrep.rb Addresses.txt -w -m road
echo.

echo.
echo Test case 9: Invalid combination (-p -w)
echo Expected: "Invalid combination of options"
echo Actual:
ruby rgrep.rb Addresses.txt -p -w road
echo.

echo Test case 10: Invalid combination (-c -m)
echo Expected: "Invalid combination of options"
echo Actual:
ruby rgrep.rb Addresses.txt -c -m road
echo.

echo Test case 11: Invalid combination (-v -m)
echo Expected: "Invalid combination of options"
echo Actual:
ruby rgrep.rb Addresses.txt -v -m road
echo.

echo Test case 12: Duplicate options
echo Expected: Same as -p road (lines containing "road")
echo Actual:
ruby rgrep.rb Addresses.txt -p -p road
echo.

echo Test case 13: Complex regex pattern
echo Expected: Lines starting with digits followed by space and word (all lines except "Lyndhurst Pl 224")
echo Actual:
ruby rgrep.rb Addresses.txt -p "^\d+\s\w+"
echo.

echo Test case 14: Non-existent file
echo Expected: "File not found : NonExistentFile.txt"
echo Actual:
ruby rgrep.rb NonExistentFile.txt -p test
echo.

echo Test case 15: Pattern with special regex characters
echo Expected: Lines ending with "Street" (only "234 Johnson Street")
echo Actual:
ruby rgrep.rb Addresses.txt -p "[Ss]treet$"
echo.

echo.
echo Test case 16: Count lines with word
echo Expected: 2 (number of lines containing whole word "road")
echo Actual:
ruby rgrep.rb Addresses.txt -w -c road
echo.

echo Test case 17: Count lines with regex pattern
echo Expected: 4 (number of lines starting with digits)
echo Actual:
ruby rgrep.rb Addresses.txt -c "^\d+"
echo.

echo Test case 18: Inverted search with count
echo Expected: 3 (number of lines without "road")
echo Actual:
ruby rgrep.rb Addresses.txt -v -c "road"
echo.

echo Test case 19: Pattern that matches the entire line
echo Expected: One line: "102 high road"
echo Actual:
ruby rgrep.rb Addresses.txt -p "^102 high road$"
echo.

echo Test case 20: Word boundary test
echo Expected: One line: "101 broad lane" (containing whole word "broad")
echo Actual:
ruby rgrep.rb Addresses.txt -w broad
echo.

echo.
echo Test case 21: Invalid regex pattern
echo Expected: "Invalid regular expression: ["
echo Actual:
ruby rgrep.rb Addresses.txt -p "["
echo.

echo Test case 22: Missing pattern
echo Expected: "Missing required arguments"
echo Actual:
ruby rgrep.rb Addresses.txt -p
echo.

echo Test case 23: Empty pattern
echo Expected: All lines (empty pattern matches everything)
echo Actual:
ruby rgrep.rb Addresses.txt -p ""
echo.

pause
