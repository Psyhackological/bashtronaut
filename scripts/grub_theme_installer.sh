#!/bin/bash

# Install git if not installed
if ! command -v git &>/dev/null; then
    echo "Git is not installed. Please install Git and rerun this script."
    exit
fi

# Change to home directory
cd ~/ || exit

# Clone the repository
git clone https://github.com/AdisonCavani/distro-grub-themes.git

# Auto-detect grub directory
if [ -d "/boot/grub" ]; then
    grub_dir="/boot/grub"
elif [ -d "/boot/grub2" ]; then
    grub_dir="/boot/grub2"
else
    echo "Unable to auto-detect GRUB directory. Exiting..."
    exit
fi

echo "Detected GRUB directory: ${grub_dir}"

# Create themes directory
sudo mkdir -p "$grub_dir"/themes

# Change directory
cd ~/distro-grub-themes/themes || exit

# Unpack tar archives and list the themes
echo "Available themes are:"
for i in *.tar; do
    tar_name="${i%%.*}"
    echo "$tar_name"
    tar -xf "$i"
done

# Prompt the user for the theme name
read -rp "Enter the name of the theme you want to install: " theme_name

# Check if the theme exists
if [ ! -d "$theme_name" ]; then
    echo "Theme '${theme_name}' does not exist. Please rerun this script and enter a valid theme."
    exit
fi

# Copy theme
sudo cp -r "$theme_name"/ "$grub_dir"/themes

# Update /etc/default/grub with the selected theme
sudo sed -i 's/^#GRUB_GFXMODE=.*/GRUB_GFXMODE=1920x1080/' /etc/default/grub
sudo sed -i 's/^GRUB_TERMINAL_OUTPUT=.*/#GRUB_TERMINAL_OUTPUT="console"/' /etc/default/grub
echo "GRUB_THEME=\"${grub_dir}/themes/${theme_name}/theme.txt\"" | sudo tee -a /etc/default/grub

# Prompt the user for the grub config command
echo "Please enter the command to update grub configuration:"
echo "1. Ubuntu and Debian-based systems: update-grub"
echo "2. Fedora, Arch & others: grub-mkconfig -o BOOT_GRUB_LOCATION/grub.cfg"
echo "3. Fedora, Arch & others: grub2-mkconfig -o BOOT_GRUB_LOCATION/grub.cfg"

read -rp "Enter your choice (1-3): " choice

# Update Grub config
case $choice in
    1) sudo update-grub ;;
    2) sudo grub-mkconfig -o "$grub_dir"/grub.cfg ;;
    3) sudo grub2-mkconfig -o "$grub_dir"/grub.cfg ;;
    *) echo "Invalid choice. Please rerun this script and enter a valid option." ;;
esac
