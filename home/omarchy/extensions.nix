{ ... }:

{
  # Override omarchy menu functions.
  # See ~/.local/share/omarchy/bin/omarchy-menu for available functions.
  # WARNING: Overridden functions won't auto-update when omarchy changes.
  #
  # xdg.configFile."omarchy/extensions/menu.sh" = {
  #   executable = true;
  #   text = ''
  #     #!/usr/bin/env bash
  #     show_about() {
  #       exec omarchy-launch-or-focus-tui "bash -c 'fastfetch; read -n 1'"
  #     }
  #   '';
  # };
}
