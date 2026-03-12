#!/usr/bin/env bash
# Compares live omarchy/mise state against what's declared in the nix flake.
# Run this after using the omarchy menu to see what needs capturing.

set -euo pipefail

FLAKE_DIR="$(cd "$(dirname "$0")" && pwd)"
HOOKS_NIX="$FLAKE_DIR/home/omarchy/hooks.nix"
EXTENSIONS_NIX="$FLAKE_DIR/home/omarchy/extensions.nix"
THEMED_NIX="$FLAKE_DIR/home/omarchy/themed.nix"
PACKAGES_NIX="$FLAKE_DIR/home/packages/default.nix"

MISE_CONFIG="$HOME/.config/mise/config.toml"
OMARCHY_CONFIG="$HOME/.config/omarchy"

YELLOW='\033[1;33m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
RESET='\033[0m'

found_drift=0

section() { echo -e "\n${CYAN}── $1 ──${RESET}"; }

# --- Mise dev environments ---
section "Mise dev environments"

# Parse tools from live mise config
declare -A live_tools
if [[ -f "$MISE_CONFIG" ]]; then
  while IFS='= ' read -r key value; do
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs | tr -d '"')
    [[ -z "$key" || "$key" == \[* || "$key" == \#* ]] && continue
    live_tools["$key"]="$value"
  done < "$MISE_CONFIG"
fi

# Parse tools from hooks.nix (mise use --global lines)
declare -A nix_tools
while IFS= read -r line; do
  if [[ "$line" =~ mise\ use\ --global\ ([a-zA-Z0-9_-]+)@(.+) ]]; then
    tool="${BASH_REMATCH[1]}"
    version="${BASH_REMATCH[2]}"
    nix_tools["$tool"]="$version"
  fi
done < "$HOOKS_NIX"

# Compare
drift=0
for tool in "${!live_tools[@]}"; do
  ver="${live_tools[$tool]}"
  if [[ -z "${nix_tools[$tool]+x}" ]]; then
    echo -e "  ${YELLOW}+ $tool@$ver${RESET}  (installed but not in hooks.nix)"
    echo "    Add to hooks.nix:  mise use --global $tool@$ver"
    drift=1
  elif [[ "${nix_tools[$tool]}" != "$ver" ]]; then
    echo -e "  ${YELLOW}~ $tool${RESET}  version drift: hooks.nix has ${nix_tools[$tool]}, live has $ver"
    echo "    Update in hooks.nix:  mise use --global $tool@$ver"
    drift=1
  fi
done

for tool in "${!nix_tools[@]}"; do
  if [[ -z "${live_tools[$tool]+x}" ]]; then
    echo -e "  ${YELLOW}? $tool@${nix_tools[$tool]}${RESET}  (in hooks.nix but not installed)"
    drift=1
  fi
done

if [[ $drift -eq 0 ]]; then
  echo -e "  ${GREEN}In sync.${RESET}"
else
  found_drift=1
fi

# --- Omarchy hooks ---
section "Omarchy hooks"

drift=0
for hook_sample in "$OMARCHY_CONFIG"/hooks/*.sample; do
  [[ -f "$hook_sample" ]] || continue
  hook_name=$(basename "$hook_sample" .sample)
  hook_active="$OMARCHY_CONFIG/hooks/$hook_name"
  if [[ -f "$hook_active" ]] && ! grep -q "omarchy/hooks/$hook_name" "$HOOKS_NIX" 2>/dev/null; then
    echo -e "  ${YELLOW}+ $hook_name${RESET}  (active hook not managed by flake)"
    drift=1
  fi
done

# Check for any non-sample hook files not in the nix config
for hook_file in "$OMARCHY_CONFIG"/hooks/*; do
  [[ -f "$hook_file" ]] || continue
  name=$(basename "$hook_file")
  [[ "$name" == *.sample ]] && continue
  if ! grep -q "omarchy/hooks/$name" "$HOOKS_NIX" 2>/dev/null; then
    echo -e "  ${YELLOW}+ $name${RESET}  (active hook not managed by flake)"
    drift=1
  fi
done

if [[ $drift -eq 0 ]]; then
  echo -e "  ${GREEN}In sync.${RESET}"
else
  found_drift=1
fi

# --- Omarchy extensions ---
section "Omarchy extensions"

drift=0
menu_ext="$OMARCHY_CONFIG/extensions/menu.sh"
if [[ -f "$menu_ext" ]]; then
  # Check if the file has actual (non-comment, non-empty) content
  has_content=$(grep -cvE '^\s*#|^\s*$' "$menu_ext" 2>/dev/null || true)
  if [[ "$has_content" -gt 0 ]]; then
    if ! grep -qv '^\s*#' <(grep 'omarchy/extensions/menu.sh' "$EXTENSIONS_NIX" 2>/dev/null) 2>/dev/null; then
      echo -e "  ${YELLOW}+ menu.sh${RESET}  has custom functions not captured in extensions.nix"
      echo "    Review: $menu_ext"
      drift=1
    fi
  fi
fi

if [[ $drift -eq 0 ]]; then
  echo -e "  ${GREEN}In sync.${RESET}"
else
  found_drift=1
fi

# --- Omarchy themed templates ---
section "Omarchy themed templates"

drift=0
for tpl in "$OMARCHY_CONFIG"/themed/*.tpl; do
  [[ -f "$tpl" ]] || continue
  tpl_name=$(basename "$tpl")
  if ! grep -q "$tpl_name" "$THEMED_NIX" 2>/dev/null; then
    echo -e "  ${YELLOW}+ $tpl_name${RESET}  (custom template not in themed.nix)"
    echo "    Review: $tpl"
    drift=1
  fi
done

if [[ $drift -eq 0 ]]; then
  echo -e "  ${GREEN}In sync.${RESET}"
else
  found_drift=1
fi

# --- Omarchy custom themes ---
section "Omarchy custom themes"

drift=0
if [[ -d "$OMARCHY_CONFIG/themes" ]]; then
  for theme_dir in "$OMARCHY_CONFIG"/themes/*/; do
    [[ -d "$theme_dir" ]] || continue
    theme_name=$(basename "$theme_dir")
    if ! grep -rq "$theme_name" "$FLAKE_DIR/home/omarchy/" 2>/dev/null; then
      echo -e "  ${YELLOW}+ $theme_name${RESET}  (custom theme not tracked in flake)"
      drift=1
    fi
  done
fi

if [[ $drift -eq 0 ]]; then
  echo -e "  ${GREEN}In sync.${RESET}"
else
  found_drift=1
fi

# --- Summary ---
echo ""
if [[ $found_drift -eq 1 ]]; then
  echo -e "${YELLOW}Drift detected.${RESET} Update your flake, then run: ./rebuild.sh"
else
  echo -e "${GREEN}Everything is in sync.${RESET}"
fi
