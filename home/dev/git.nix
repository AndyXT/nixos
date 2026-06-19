{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "AndyXT";
      user.email = "AndyXT@users.noreply.github.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      credential.helper = "!/usr/bin/env gh auth git-credential";
      diff.tool = "difftastic";
      difftool.prompt = false;
      difftool.difftastic.cmd = ''difft "$LOCAL" "$REMOTE"'';
    };
  };
}
