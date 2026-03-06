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
    # Source omarchy's bash configuration
    source ~/.local/share/omarchy/default/bash/rc
  '';

  programs.bash.shellAliases = {
    # Add personal aliases here, e.g.:
    # ll = "ls -la";
  };
}
