#!/bin/bash

# Print the logo
print_logo() {
    cat << "EOF"


   __  ______  __  ___   __________  ______ 
  / / / / __ )/ / / / | / /_  __/ / / / __ \
 / / / / __  / / / /  |/ / / / / / / / /_/ /
/ /_/ / /_/ / /_/ / /|  / / / / /_/ / ____/ 
\____/_____/\____/_/ |_/ /_/  \____/_/                                                 


EOF
}

# Clear the terminal and print the logo
clear
print_logo

# Exit on any error
set -e

# Source the package list
if [ ! -f "utils.sh" ]; then
  echo "Error: utils.sh not found!"
  exit 1
fi

source utils.sh

# Source the package list
if [ ! -f "packages.conf" ]; then
  echo "Error: packages.conf not found!"
  exit 1
fi

source packages.conf

# Update APT
echo "Updating apt..."
sudo apt update

# Upgrade packages
echo "Upgrading packages..."
sudo apt upgrade -y

# Install APT packages
echo "Installing packages..."
install_package "${SYSTEM_UTILS[@]}"
install_package "${DEV_TOOLS[@]}"
install_extended_package "${EXTENDED_DEV_TOOLS[@]}"

# Clean up APT
sudo apt clean