{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Add standalone packages here, e.g.:
    # ripgrep
    # fd
    # jq
  ];
}
