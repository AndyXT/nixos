{ pkgs, ... }:

{
  imports = [
    ./dev
    ./shell
  ];

  home.username = "axtreto";
  home.homeDirectory = "/home/axtreto";
  home.stateVersion = "24.11";

  home.packages = [
    # Add standalone packages here
  ];

  programs.home-manager.enable = true;
}
