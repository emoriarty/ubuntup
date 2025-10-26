#!/bin/bash
set -euo pipefail

REPO_URL="https://github.com/emoriarty/dotfiles"
REPO_NAME="dotfiles"

cd ~

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL"
fi

# Check if the clone was successful
if [ $? -eq 0 ]; then
  cd "$REPO_NAME"
  stow nvim
  stow tmux
  stow editorconfig
  stow starship
  stow alacritty
  stow bash_ubuntu
else
  echo "Failed to clone the repository."
  exit 1
fi

# Complements
## Alacritty Themes
ALACRITTY_PATH=~/.config/alacritty
ALACRITTY_THEMES_PATH=${ALACRITTY_PATH}/themes

if [ ! -d $ALACRITTY_THEMES_PATH ]; then
  # Download themes
  mkdir -p $ALACRITTY_THEMES_PATH
  git clone https://github.com/alacritty/alacritty-theme $ALACRITTY_THEMES_PATH
else
  # Update themes
  git -C $ALACRITTY_THEMES_PATH pull
fi

# Verify .gitignore exists
if [ ! -f $ALACRITTY_PATH/.gitignore ]; then
  touch $ALACRITTY_PATH/.gitignore
fi

# Look for themes folder in file
if ! grep -Fxq "themes/" $ALACRITTY_PATH/.gitignore; then
  echo "themes/" >> $ALACRITTY_PATH/.gitignore
fi

