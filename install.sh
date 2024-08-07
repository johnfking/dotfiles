#!/bin/bash

git clone https://github.com/johnfking/dotfiles.git "$HOME/dotfiles"

if ! grep -q "source ~/dotfiles/.bashrc" "$HOME/.bashrc"; then
  echo "Appending dotfiles .bashrc to the current .bashrc..."
  echo -e "\n# Source dotfiles .bashrc\nsource \$HOME/dotfiles/.bashrc" >> "$HOME/.bashrc"
fi

source "$HOME/.bashrc"
