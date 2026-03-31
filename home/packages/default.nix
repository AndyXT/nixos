{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ruff
    ty
    typst
    uv
  ];
}
