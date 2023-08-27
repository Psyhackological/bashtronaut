#!/bin/bash

function extract_subtitle {
    local VIDEO_FILE=$1
    local LANGUAGE_CODE=$2

    # Construct the output file names
    local BASE_NAME
    BASE_NAME=$(basename "$VIDEO_FILE" .mkv)
    local SUBTITLE_FILE="${BASE_NAME}_${LANGUAGE_CODE}.srt"
    local CLEAN_SUBTITLE_FILE="${BASE_NAME}_${LANGUAGE_CODE}.txt"

    # Find the index of the subtitle stream in the selected language
    local SUBTITLE_INDEX
    SUBTITLE_INDEX=$(ffprobe -v error -select_streams s -show_entries stream=index:stream_tags=language -of csv=p=0 "$VIDEO_FILE" | awk -F, -v lang="$LANGUAGE_CODE" '$2==lang {print $1-2}')

    # Check if subtitle file exists
    if [[ ! -f "$SUBTITLE_FILE" ]]; then
        # Extract subtitles if the file does not exist
        ffmpeg -i "$VIDEO_FILE" -map 0:s:"$SUBTITLE_INDEX" -c:s srt -y "$SUBTITLE_FILE"
    fi

    # Remove timestamps, digits, and empty lines and redirect to clean subtitle file
    sed -r '/^[0-9]+$/d;/^[0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3} --> [0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}$/d;/^$/d' "$SUBTITLE_FILE" >"$CLEAN_SUBTITLE_FILE"
}

function main {
    # Check if a language code was provided
    if [[ $# -ne 1 ]]; then
        echo "Usage: $0 language_code"
        exit 1
    fi
    local LANGUAGE_CODE=$1

    # Iterate over all .mkv files in the current directory
    for VIDEO_FILE in *.mkv; do
        extract_subtitle "$VIDEO_FILE" "$LANGUAGE_CODE"
    done
}

main "$@"
