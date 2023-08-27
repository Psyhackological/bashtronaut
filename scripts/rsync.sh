#!/bin/bash

start="$(date +%s)"

# Set the variables
SOURCE_DIR="$HOME"
BACKUP_DIR="/run/media/$USER/SamsungT7/rsync"
EXCLUDE_FILE="/run/media/$USER/SamsungT7/rsync/rsync-exclude.txt"

# Create the backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Check if backup directory exists and is writable
if [ ! -d "$BACKUP_DIR" ] || [ ! -w "$BACKUP_DIR" ]; then
	echo "Error: Backup directory $BACKUP_DIR does not exist or is not writable."
	exit 1
fi

EXCLUDES="
.local/
.cache/
.android/
.gradle/
.rustup/
.cargo/
.vagrant.d/
.pub-cache/
.npm/
.wine/
.nuget/
.dartServer/
.vscode/
.vscode-oss/
.vscode-insiders/
.azuredatastudio/
.ghcup/
Music/
Games/
.config/ludusavi/
.config/azuredatastudio/
.config/Code/
.config/Code - Insiders/
.config/VSCodium/
.config/BraveSoftware/
.config/heroic/
.config/Ferdi/
.config/Ferdium/
.config/tidal-hifi/
.Trash*/
/tmp
*~
.swp
sudoers.bak
*/target/debug/
*/Cache/
*/Code Cache/
*/DawnCache/
*/GPUCache/
*/Cache_Data/
*/__pycache__/
*/cache/
*/CacheStorage/
*/ScriptCache/
*/AssetRegistryCache/
"

# Create an rsync exclude file to exclude unnecessary files
echo "$EXCLUDES" >"$EXCLUDE_FILE"

# Create a list of installed packages
mkdir -p "$BACKUP_DIR/packages/"
paru -Qqe >"$BACKUP_DIR"/packages/paru_list.txt
cargo install --list >"$BACKUP_DIR"/packages/cargo_list.txt
flatpak list >"$BACKUP_DIR"/packages/flatpak_list.txt
pip freeze >"$BACKUP_DIR"/packages/python-pip_list.txt

# Run rsync
rsync -aAXv --delete --delete-excluded --prune-empty-dirs --exclude-from="$EXCLUDE_FILE" --log-file="$BACKUP_DIR/rsync.log" "$SOURCE_DIR" "$BACKUP_DIR"

end="$(date +%s)"
diff="$((end - start))"

# Output the date and time of backup
echo "Backup completed at $(date)" >>"$BACKUP_DIR"/backup.log
echo "it took $diff seconds"
