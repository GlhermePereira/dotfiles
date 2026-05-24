#!/bin/bash

set -e

PACKAGES_FILE="$HOME/dotfiles/packages/debian.txt"

sudo apt update

xargs -a "$PACKAGES_FILE" sudo apt install -y

echo
echo "Instalação concluída."
