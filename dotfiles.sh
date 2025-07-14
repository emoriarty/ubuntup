#!/bin/bash

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
  stow zsh
  stow nvim
  stow tmux
  stow editorconfig
  stow starship
  stow alacritty
else
  echo "Failed to clone the repository."
  exit 1
fi
