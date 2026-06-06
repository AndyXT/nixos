#!/usr/bin/env bash
set -e

home-manager switch -b backup --flake "$HOME/nixos#axtreto"

# Install picotool udev rules if not already present
PICOTOOL_RULES="$(dirname "$(readlink -f "$(which picotool)")")/../etc/udev/rules.d/60-picotool.rules"
if [ -f "$PICOTOOL_RULES" ]; then
  if ! diff -q "$PICOTOOL_RULES" /etc/udev/rules.d/60-picotool.rules &>/dev/null; then
    echo "Updating picotool udev rules..."
    sudo cp "$PICOTOOL_RULES" /etc/udev/rules.d/
    sudo udevadm control --reload
  fi
fi
