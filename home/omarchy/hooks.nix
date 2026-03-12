{ ... }:

{
  xdg.configFile."omarchy/hooks/post-update" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Ensure mise dev environments are installed after omarchy updates.
      # Add tools here after installing them via the omarchy menu.
      mise use --global java@latest
      mise use --global node@25.7.0
      mise use --global scala@latest
      mise use --global scala-cli@latest
    '';
  };

  # Run after theme changes (receives theme name as $1):
  # xdg.configFile."omarchy/hooks/theme-set" = {
  #   executable = true;
  #   text = ''
  #     #!/usr/bin/env bash
  #     echo "Theme changed to: $1"
  #   '';
  # };

  # Run after font changes (receives font name as $1):
  # xdg.configFile."omarchy/hooks/font-set" = {
  #   executable = true;
  #   text = ''
  #     #!/usr/bin/env bash
  #     echo "Font changed to: $1"
  #   '';
  # };
}
