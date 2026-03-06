#!/usr/bin/env bash
set -e

home-manager switch -b backup --flake "$HOME/nixos#axtreto"
