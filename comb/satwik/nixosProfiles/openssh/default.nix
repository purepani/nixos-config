{ inputs, cell }:
let
  pkgs = inputs.nixpkgs.pkgs;
in
{
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    openFirewall = true;
    settings = {
      #	  PasswordAuthentication = false;
      #	  KbdInteractiveAuthentication = false;
      #	  PermitRootLogin = "yes";
      PrintMotd = true;
    };
  };
  users.motd = "Purewater's server.";


  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    askPassword = "${pkgs.systemd}/bin/systemd-ask-pass";
    extraConfig = "AddKeysToAgent yes";
  };
}
