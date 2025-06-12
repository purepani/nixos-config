{ inputs
, cell
,
}: {
  programs.git = {
    enable = true;
    userName = "purepani";
    userEmail = "pani0028@umn.edu";
    signing = {
      key = null;
      signByDefault = true;
    };
    extraConfig = {
      commit.gpgsign = true;
      #gpg.format = "ssh";
      #gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      #user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };
  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    pinentry.package = cell.nixpkgs.pkgs.pinentry-tty;
    #enableSshSupport = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    extraConfig = ''
      	allow-loopback-pinentry
    '';
  };
  programs.gpg = {
    enable = true;
    settings = {
      pinentry-mode = "loopback";
    };
  };
}
