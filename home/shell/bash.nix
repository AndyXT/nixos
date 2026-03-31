{ ... }:

{
  programs.bash.enable = true;

  programs.bash.profileExtra = ''
    # Ensure Nix profile is on PATH for login shells
    if [ -e '/etc/profile.d/nix-daemon.sh' ]; then
      source '/etc/profile.d/nix-daemon.sh'
    fi
  '';

  programs.bash.initExtra = ''
    # Iterative rg+fzf search: rfv [pattern] — refine with Ctrl-R (lines) / Ctrl-F (files)
    rfv() {
      local tmpfile
      tmpfile=$(mktemp)
      trap 'rm -f "$tmpfile" "$tmpfile.tmp" "$tmpfile.term" "$tmpfile.clean"; unset RFV_TERM_FILE' RETURN

      if [[ $# -gt 0 ]]; then
        rg --line-number --no-heading --color=always "$@" . > "$tmpfile"
        echo "''${!#}" > "$tmpfile.term"
      else
        rg --line-number --no-heading "." . > "$tmpfile"
        echo "" > "$tmpfile.term"
      fi
      export RFV_TERM_FILE="$tmpfile.term"

      [[ ! -s "$tmpfile" ]] && echo "No results." && return

      local selection
      selection=$(fzf --ansi \
        --delimiter : \
        --header="Enter: open | Ctrl-R: clear query | Ctrl-S: rg lines | Ctrl-F: rg files" \
        --bind "ctrl-r:execute-silent(fzf --ansi --filter {q} < $tmpfile | sed 's/\x1b\[[0-9;]*m//g' > $tmpfile.tmp && mv $tmpfile.tmp $tmpfile)+reload(cat $tmpfile)+clear-query" \
        --bind "ctrl-s:execute-silent(sed 's/\x1b\[[0-9;]*m//g' $tmpfile > $tmpfile.clean && rg --no-filename --color=always -- {q} $tmpfile.clean > $tmpfile.tmp && mv $tmpfile.tmp $tmpfile && rm -f $tmpfile.clean && echo {q} > $tmpfile.term)+reload(cat $tmpfile)+clear-query" \
        --bind "ctrl-f:execute-silent(sed 's/\x1b\[[0-9;]*m//g' $tmpfile | cut -d: -f1 | sort -u | xargs rg --line-number --no-heading --color=always -- {q} > $tmpfile.tmp && mv $tmpfile.tmp $tmpfile && echo {q} > $tmpfile.term)+reload(cat $tmpfile)+clear-query" \
        --preview='clean=$(echo {} | sed "s/\x1b\[[0-9;]*m//g"); file=$(echo "$clean" | cut -d: -f1); line=$(echo "$clean" | cut -d: -f2); term=$(cat "$RFV_TERM_FILE" 2>/dev/null); if [[ -n "$term" ]]; then bat --style=numbers --color=always --highlight-line "$line" "$file" 2>/dev/null | rg --color=always --passthru -- "$term"; else bat --style=numbers --color=always --highlight-line "$line" "$file" 2>/dev/null; fi' \
        --preview-window='up,60%,+{2}-5' \
        < "$tmpfile")

      [[ -z "$selection" ]] && return

      local file line clean
      clean=$(echo "$selection" | sed 's/\x1b\[[0-9;]*m//g')
      file=$(echo "$clean" | cut -d: -f1)
      line=$(echo "$clean" | cut -d: -f2)
      ''${EDITOR:-vim} "+''${line}" "$file"
    }

    # Source omarchy's bash configuration
    source ~/.local/share/omarchy/default/bash/rc
  '';

  programs.bash.shellAliases = {
    # Add personal aliases here, e.g.:
    # ll = "ls -la";
  };
}
