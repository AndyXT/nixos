{ ... }:

{
  imports = [
    ./dev
    ./shell
    ./packages
    ./omarchy
  ];

  home.username = "axtreto";
  home.homeDirectory = "/home/axtreto";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
