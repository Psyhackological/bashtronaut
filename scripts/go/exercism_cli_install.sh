#!/bin/bash

# Define variables
EXERCISM_API_URL="https://api.github.com/repos/exercism/cli/releases/latest"
DOWNLOAD_FOLDER="/tmp"
BIN_FOLDER="$HOME/bin"
TARBALL_NAME="exercism.tar.gz"
TARBALL_PATH="$DOWNLOAD_FOLDER/$TARBALL_NAME"

# Check if Exercism CLI is already installed
if [ -x "$BIN_FOLDER/exercism" ]; then
	echo "Exercism CLI is already installed."
	"$BIN_FOLDER/exercism"
	exit 0
fi

# Function to get the latest Exercism CLI release URL
get_latest_exercism_url() {
	curl -s "$EXERCISM_API_URL" |
		grep "browser_download_url.*linux-x86_64.tar.gz" |
		cut -d \" -f 4
}

# Download the latest release
echo "Downloading Exercism CLI..."
download_url=$(get_latest_exercism_url)
if curl -L "$download_url" --output "$TARBALL_PATH"; then
	echo "Downloaded Exercism CLI."
else
	echo "Failed to download Exercism CLI. Exiting."
	exit 1
fi

# Unpack and clean up
echo "Unpacking..."
if tar -xf "$TARBALL_PATH" -C "$DOWNLOAD_FOLDER"; then
	rm "$TARBALL_PATH"
else
	echo "Failed to unpack Exercism CLI. Exiting."
	exit 1
fi

# Move executable to ~/bin
echo "Setting up the executable..."
if mv "${DOWNLOAD_FOLDER}/exercism" "$BIN_FOLDER"; then
	echo "Executable moved to $BIN_FOLDER."
else
	echo "Failed to move the executable. Exiting."
	exit 1
fi

# Add ~/bin to $PATH if it's not already there
if [[ ":$PATH:" != *":$BIN_FOLDER:"* ]]; then
	echo 'export PATH=~/bin:$PATH' >>~/.bash_profile
	source ~/.bash_profile
	echo "~/bin added to PATH"
else
	echo "~/bin is already in PATH"
fi

# Check installation
echo "Checking the Exercism CLI installation..."
if [ -x "$BIN_FOLDER/exercism" ]; then
	"$BIN_FOLDER/exercism"
else
	echo "Exercism CLI is not executable or not found in $BIN_FOLDER."
fi
