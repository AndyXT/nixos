{ ... }:

{
  programs.git = {
    enable = true;
    userName = "YOUR NAME";
    userEmail = "YOUR EMAIL";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
