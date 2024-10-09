{ inputs, cell }: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user.name = "purepani";
      user.email = "pani0028@umn.edu";
      signing.signall = true;
    };
  };
}
