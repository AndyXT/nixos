{ ... }:

{
  # Manage scripts in ~/.config/omarchy/hooks/
  # Available hooks: post-update, theme-set, font-set
  #
  # Example — run something after omarchy updates:
  # xdg.configFile."omarchy/hooks/post-update" = {
  #   executable = true;
  #   text = ''
  #     #!/usr/bin/env bash
  #     echo "omarchy updated"
  #   '';
  # };
}
