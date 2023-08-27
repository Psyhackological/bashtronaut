#!/bin/bash

# Create a directory named "Shorts" if it doesn't exist
mkdir -p Shorts

# Loop over each .webm and .mkv file in the current directory
for file in *.webm *.mkv; do
	# Check if the file exists (this is needed because if there are no matches, the loop still runs once)
	if [ -f "$file" ]; then
		# Use ffprobe to get the duration of the video in seconds, rounded to the nearest integer
		duration=$(ffprobe -i "$file" -show_entries format=duration -v quiet -of csv="p=0" | awk '{print int($1+0.5)}')

		# Check if the video duration is less than 60 seconds
		if [ "$duration" -lt 60 ]; then
			# Move the file to the "Shorts" directory
			mv "$file" Shorts/
		fi
	fi
done
