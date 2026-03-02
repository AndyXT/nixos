#!/usr/bin/env bash
set -e

# Enable flakes in system nix.conf if not already set
if ! grep -q "experimental-features" /etc/nix/nix.conf 2>/dev/null; then
  echo "Adding flakes to /etc/nix/nix.conf..."
  echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
  sudo systemctl restart nix-daemon
fi

# Back up existing shell files that home-manager will manage
for f in "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.profile"; do
  if [ -f "$f" ] && [ ! -L "$f" ]; then
    echo "Backing up $f to ${f}.backup"
    mv "$f" "${f}.backup"
  fi
done

# Bootstrap home-manager using nix run (since it's not installed yet)
nix run home-manager/master -- switch --flake "$HOME/nixos#axtreto"
