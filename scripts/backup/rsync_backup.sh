#!/bin/bash

directories=(
    "$HOME/.anacron"
    "$HOME/.bash_aliases"
    "$HOME/.bash_history"
    "$HOME/.bash_logout"
    "$HOME/.bash_profile"
    "$HOME/.bashrc"
    "$HOME/.profile"
    "$HOME/.gitconfig"
    "$HOME/.librewolf"
    "$HOME/.config/alacritty"
    "$HOME/.config/calibre"
    "$HOME/.config/chezmoi"
    "$HOME/.config/cmus"
    "$HOME/.config/exercism"
    "$HOME/.config/fish"
    "$HOME/.config/ludusavi"
    "$HOME/.config/mpv"
    "$HOME/.config/nvim"
    "$HOME/.config/topgrade.toml"
    "$HOME/.config/yt-dlp"
    "$HOME/.config/zathura"
    "$HOME/.config/zellij"
    "$HOME/.ssh"
    "$HOME/.tidal-dl.json"
    "$HOME/.tidal-dl.token.json"
    "$HOME/.tmux.conf"
    "$HOME/Applications"
    "$HOME/bin"
    "$HOME/Calibre Library"
    "$HOME/Desktop"
    "$HOME/Documents"
    "$HOME/Downloads"
    "$HOME/Music"
    "$HOME/Pictures"
    "$HOME/Public"
    "$HOME/Templates"
    "$HOME/Videos"
    "$HOME/my_scripts"
)

backup_destination="/media/konradkon/SamsungT7/2024_backup/cosmic_lets_go/rsync"

RSYNC_FLAGS=(
    -avhPum
    --delete
    --exclude-from='rsync_exclude.txt'
    --log-file='rsync.log'
    --relative
    --backup
    --suffix=.bak
    --backup-dir='backup'
)

# Filter out non-existent directories
existing_directories=()
for dir in "${directories[@]}"; do
    if [ -e "$dir" ]; then
        existing_directories+=("$dir")
    else
        echo "Warning: $dir does not exist and will be skipped."
    fi
done

rsync "${RSYNC_FLAGS[@]}" "${existing_directories[@]}" "$backup_destination"
