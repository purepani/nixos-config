{
  inputs,
  cell,
}: {
  programs.git = {
    enable = true;
    userName = "purepani";
    userEmail = "pani0028@umn.edu";
    extraConfig = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };
}
