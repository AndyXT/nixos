{ ... }:

{
  # Override theme templates. Files here override system templates
  # in ~/.local/share/omarchy/default/themed/ when a theme is applied.
  #
  # Use {{ color_name }} placeholders — they get substituted with
  # values from the active theme's colors.toml.
  #
  # To customize, copy a .tpl.sample from ~/.config/omarchy/themed/,
  # rename to .tpl, edit, and add it here.
  #
  # Example — custom alacritty template:
  # xdg.configFile."omarchy/themed/alacritty.toml.tpl" = {
  #   text = ''
  #     [colors.primary]
  #     background = "{{ background }}"
  #     foreground = "{{ foreground }}"
  #   '';
  # };
}
