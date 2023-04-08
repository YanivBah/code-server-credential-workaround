#!/bin/bash

function success {
  echo -e "\033[0;32m$1\033[0m$2"
}

function error {
  echo -e "\033[0;31m$1\033[0m$2" >&2
}

# Check if the script is running with sudo privileges
if [ "$EUID" -ne 0 ]; then
  error "ERROR: This script requires sudo privileges to run. Please run it with sudo."
  exit 1
fi

# When running with sudo, the $HOME variable is set to /root instead of the user's home directory (e.g. /home/user)
# This line sets the $HOME variable to the user's home directory
export HOME=$(getent passwd $(echo $SUDO_USER) | cut -d: -f6)

keytar_path="/usr/lib/code-server/lib/vscode/node_modules/keytar/lib/keytar.js"
if [ ! -f "$keytar_path" ]; then
  error "ERROR: Cant find the keytar.js file. Are you sure you have code-server installed?"
  exit 1
fi

cp $keytar_path $keytar_path.backup
success "Backup of keytar.js created." " ($keytar_path.backup)"

creds_dir="${HOME}/.config/code-server/creds"

read -p $'\nEnter a directory path for the credientials directory [default: '"$creds_dir"$']\n' creds_dir_input

if [ -n "$creds_dir_input" ]; then
  creds_dir="$creds_dir_input"
fi

success "The directory for credentials is set to" " $creds_dir"
read -p "Are you sure? [y/N] " confirm_directory

if [ "$confirm_directory" != "y" ] && [ "$confirm_directory" != "Y" ]; then
  echo "Exiting..."
  exit 1
fi

if command -v curl &> /dev/null; then
  curl -sSf -o "$keytar_path" https://raw.githubusercontent.com/stevenlafl/node-keytar/master/lib/keytar.js
  success "keytar.js file modified successfully."
else
  error "ERROR: curl is not installed. Exiting..."
fi

# Find the line starting with "let credsDir" and replace it with the user's input
sed -i "/let credsDir/c\let credsDir = '$creds_dir';" "$keytar_path"
