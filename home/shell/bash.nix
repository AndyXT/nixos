{ ... }:

{
  programs.bash.enable = true;
  programs.bash.initExtra = ''
    # Ensure Nix profile is on PATH (needed for non-login shells)
    if [ -e '/etc/profile.d/nix-daemon.sh' ]; then
      source '/etc/profile.d/nix-daemon.sh'
    fi

    source ~/.local/share/omarchy/default/bash/rc
  '';
}
