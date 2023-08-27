#!/bin/bash

# Function to get the latest Proton-GE-Custom release URL
get_latest_proton_ge_url() {
    curl -s "https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest" |
    grep "browser_download_url.*\.tar\.gz" |
    cut -d \" -f 4
}

# Function to download and verify the Proton-GE-Custom archive
download_proton_ge() {
    local url
    url="$1"
    local filename
    filename="$(basename "$url")"
    echo "--> Downloading $filename..."
    curl -L "$url" --output "$filename"

    # Verify file integrity if sha512sum is available and a hash can be obtained
    if hash sha512sum && sha512_hash=$(curl -Lf "${url%.tar.gz}.sha512sum" 2>/dev/null); then
        echo "--> Verifying file integrity..."
        if ! printf '%s' "${sha512_hash%% *}  ${filename}" | sha512sum -c /dev/stdin; then
            # If stdin is a terminal, we ask whether to accept a failed checksum or exit
            if [ -t 0 ]; then
                while true; do
                    printf '%s' "--> File integrity check failed. Continue?  (y/[N]) "
                    read -r REPLY
                    case "$REPLY" in
                        [yY][eE][sS] | [yY]) break ;;
                        [nN][oO] | [nN] | '') exit 1 ;;
                        *) echo "Invalid input..." ;;
                    esac
                done
            else
                echo "--> ERROR: File integrity check failed." 1>&2
                exit 1
            fi
        fi
    else
        echo "--> Skipping file integrity check (hash not found)."
    fi
}

# Function to install the Proton-GE-Custom archive
install_proton_ge() {
    local steam_path
    steam_path="$1"
    local comp_tools_path
    comp_tools_path="$steam_path/compatibilitytools.d"
    local url
    url="$(get_latest_proton_ge_url)"
    local filename
    filename="$(basename "$url")"
    local dirname
    dirname="$(basename "$filename" .tar.gz)"
    local target_dir
    target_dir="$comp_tools_path/$dirname"

    # Check if the current version is already installed
    if [ -d "$target_dir" ]; then
        echo "--> Current version is already installed."
        return 0
    fi

    download_proton_ge "$url"
    echo "--> Extracting $filename..."
    mkdir -p "$comp_tools_path"
    tar -xf "$filename" -C "$comp_tools_path"
    echo "--> Removing the compressed archive..."
    rm "$filename"
    echo "--> Installation complete. Please restart Steam for the changes to take effect."
}

# Install Proton-GE-Custom for regular Steam installations
if [ -d "$HOME/.local/share/Steam" ] || [ -d "$HOME/.steam" ]; then
    echo "--> Installing for regular Steam installation..."
    install_proton_ge "$HOME/.local/share/Steam" || install_proton_ge "$HOME/.steam"
else
    echo "--> Regular Steam installation not found."
fi

# Install Proton-GE-Custom for Flatpak Steam installations
if [ -d "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam" ] || [ -d "$HOME/.var/app/com.valvesoftware.Steam/.steam" ]; then
    echo "--> Installing for Flatpak Steam installation..."
    install_proton_ge "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam" || install_proton_ge "$HOME/.var/app/com.valvesoftware.Steam/.steam"
else
    echo "--> Flatpak Steam installation not found."
fi
