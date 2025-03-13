{ inputs, cell }: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user.name = "purepani";
      user.email = "pani0028@umn.edu";
      signing = {
        behavior = "drop";
        backend = "gpg";
        key = "pani0028@umn.edu";
      };
      git = {
        sign-on-push = true;
      };
    };
  };
}
