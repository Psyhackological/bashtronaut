#!/bin/bash

fetch_and_compare_version() {
	if [ "$#" -ne 2 ]; then
		echo "Usage: fetch_and_compare_version <repo_root> <repo_child>"
		return 1
	fi

	repo_root=$1
	repo_child=$2
	latest_version=$(curl -s https://api.github.com/repos/"$repo_root"/"$repo_child"/releases/latest | jq -r '.tag_name, .published_at')

	latest_version_number=$(echo "$latest_version" | sed -n 1p | sed 's/^v//') # Remove leading 'v' if present
	latest_version_date=$(echo "$latest_version" | sed -n 2p)

	installed_version_info=$("$repo_child" --version 2>&1 | head -n 1)
	installed_version_number=$(echo "$installed_version_info" | grep -oP '\d+(\.\d+)+')

	releases=$(curl -s https://api.github.com/repos/"$repo_root"/"$repo_child"/releases)
	installed_version_date=$(echo "$releases" | jq -r ".[] | select(.tag_name | contains(\"$installed_version_number\")) | .published_at")

	echo "Installed: $installed_version_date $installed_version_number "
	echo "   Latest: $latest_version_date $latest_version_number"

	if [ "$installed_version_date" = "" ] || [ "$latest_version_date" = "" ]; then
		echo "Cannot compare dates as one of the dates is missing."
	else
		local_date_sec=$(date -d "$installed_version_date" +%s)
		remote_date_sec=$(date -d "$latest_version_date" +%s)

		let diff_sec="$remote_date_sec-$local_date_sec"
		let diff_days="$diff_sec"/86400

		echo "Time difference: $diff_days days"
	fi
}

fetch_and_compare_version "$1" "$2"
