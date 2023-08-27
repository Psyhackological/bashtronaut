#!/bin/bash

# Check if file path argument is provided
if [ "$1" = "" ]; then
    echo "Usage: $0 /path/to/image"
    exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
    echo "Error: File '$1' does not exist."
    exit 1
fi

file_path="$1"      # File path from the first argument
target_size=1048576 # 1MB in bytes
current_size=$(stat -c%s "$file_path")

# Loop to resize the image until it meets the target size
while [ "$current_size" -gt "$target_size" ]; do
    mogrify -resize 90% "$file_path"
    current_size=$(stat -c%s "$file_path")
done
