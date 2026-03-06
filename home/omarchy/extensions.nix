{ ... }:

{
  # Manage scripts in ~/.config/omarchy/extensions/
  # Extensions override default menu functions in omarchy.
  #
  # Example — override the screenshot menu:
  # xdg.configFile."omarchy/extensions/screenshot.sh" = {
  #   executable = true;
  #   text = ''
  #     #!/usr/bin/env bash
  #     grim -g "$(slurp)" - | wl-copy
  #   '';
  # };
}
