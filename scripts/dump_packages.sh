#!/bin/bash

BACKUP_DIR="/media/$USER/SamsungT7/2024_backup/cosmic_lets_go"

dump_packages() {
    mkdir -p "$BACKUP_DIR/packages/"
    nala list >"$BACKUP_DIR/packages/nala_list.txt"
    cargo install --list >"$BACKUP_DIR/packages/cargo_install_list.txt"
    flatpak list >"$BACKUP_DIR/packages/flatpak_list.txt"
    pip freeze >"$BACKUP_DIR/packages/python_freeze.txt"
    pipx list >"$BACKUP_DIR/packages/pipx_list.txt"
    tree L 2 ~/.local >"$BACKUP_DIR/packages/local.txt"
}

dump_packages
