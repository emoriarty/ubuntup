#!/bin/bash

function is_installed() {
  # check with brew if a package is installed
  local package="$1"
  if dpkg -s "$package" &> /dev/null; then
    return 0  # Package is installed
  else
    return 1  # Package is not installed
  fi
}


# Function to install packages if not already installed
function install_package() {
  local packages=("$@")
  local to_install=()

  for pkg in "${packages[@]}"; do
    if ! is_installed "$pkg"; then
      to_install+=("$pkg")
    fi
  done

  if [ ${#to_install[@]} -ne 0 ]; then
    echo "Installing packages: ${to_install[*]}"
    sudo apt install -y "${to_install[@]}"
  fi
}

function is_extended_package_installed() {
  local package="$1"

  if [[ "$package" == *::* ]]; then
    local path="${package##*::}"

    # Expand ~ manually
    [[ "$path" == ~* ]] && path="${path/#\~/$HOME}"

    [[ -e "$path" ]]  # Checks whether file or directory exists
    return $?
  else
    command -v "$package" &> /dev/null
    return $?
  fi
}


# Function to install packages if not already installed
function install_extended_package() {
  local packages=("$@")
  local to_install=()

  # Identify packages that are not installed
  for pkg in "${packages[@]}"; do
    if ! is_extended_package_installed "$pkg"; then
      to_install+=("$pkg")
    fi
  done

  # Install missing packages
  if [ ${#to_install[@]} -ne 0 ]; then
    echo "📦 Installing packages: ${to_install[*]}"
    for pkg in "${to_install[@]}"; do
      local name="${pkg%%::*}"
      local install_func="install_${name}"

      if declare -f "$install_func" > /dev/null; then
        echo "▶️ Running $install_func"
        "$install_func"
      else
        echo "⚠️ Function $install_func not found"
      fi
    done
  else
    echo "✅ All packages are already installed."
  fi
}


function install_lazygit() {
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit -D -t /usr/local/bin/
}

function install_lazydocker() {
  curl -fsSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | sudo DIR="/usr/local/bin" bash
}

function install_tpm() {
  local tpm_path="$HOME/.tmux/plugins/tpm"

  if ! [ -d "$tpm_path" ]; then
    git clone https://github.com/tmux-plugins/tpm "$tpm_path"
  fi
}
