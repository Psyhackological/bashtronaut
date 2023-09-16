#!/bin/bash

# Your mouse id from xinput
MOUSE_ID=12

# Counter
COUNT=0

# Start monitoring mouse events
xinput test "$MOUSE_ID" | while read -r line; do
    # Check for a button press event (indicated by "button press" in the output)
    if [[ $line == *"button press"* ]]; then
        # Increment counter
        COUNT=$((COUNT + 1))

        # Display the counter using kdialog
        kdialog --passivepopup "Total Clicks: $COUNT" 2
    fi
done
