{ pkgs, ... }:

{
  home.packages = [
    # xonsh's Python interpreter is managed by Nix, so `xpip install ...` won't
    # persist (and is blocked on a read-only store). Instead, add Python packages
    # and xontribs here via `extraPackages` — they become importable inside xonsh.
    (pkgs.xonsh.override {
      extraPackages = ps: with ps; [
        # Python libraries usable from any .xsh script or the prompt:
        # requests
        # numpy

        # xontribs (xonsh extensions) are just Python packages too:
        # xontrib-vox          # virtualenv management
        # xontrib-zoxide       # zoxide integration
        # xonsh-direnv         # direnv integration
      ];
    })
  ];

  # Run-control file, evaluated on every interactive xonsh start.
  xdg.configFile."xonsh/rc.xsh".text = ''
    # Inherit a sane PATH/env from the surrounding (bash) login session.
    $XONSH_SHOW_TRACEBACK = True
    $XONSH_HISTORY_BACKEND = 'sqlite'

    # Load any xontribs you added above, e.g.:
    # xontrib load vox zoxide direnv

    # Aliases / functions go here, e.g.:
    # aliases['ll'] = 'ls -la'
  '';
}
