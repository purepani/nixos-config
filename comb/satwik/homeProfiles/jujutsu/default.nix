{ inputs, cell }: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user.name = "purepani";
      user.email = "purepani@pm.me";
      ui.pager = ":builtin";
      signing = {
        behavior = "drop";
        backend = "gpg";
        key = "purepani@pm.me";
      };
      git = {
        sign-on-push = true;
      };
    };
  };
}
