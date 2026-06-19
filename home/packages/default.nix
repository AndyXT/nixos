{ pkgs, ... }:

{
  home.packages = with pkgs; [
    clj-kondo
    ruff
    ty
    typst
    uv
    vim-full
    universal-ctags
    cscope
    difftastic

    # Rust with RISC-V target support
    (rust-bin.stable.latest.default.override {
      extensions = [ "rust-analyzer" "rust-src" ];
      targets = [ "riscv32imac-unknown-none-elf" ];
    })

    # Raspberry Pi Pico 2 development
    cmake
    gnumake
    gcc-arm-embedded
    pico-sdk
    picotool
    python3
    minicom
  ];
}
