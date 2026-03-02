{ ... }:

{
  programs.bash.enable = true;
  programs.bash.initExtra = ''
    source ~/.local/share/omarchy/default/bash/rc
  '';
}
