{ inputs, cell }:
let
  inherit (cell) nixosProfiles hardwareProfiles;
  inherit (inputs.common.bee) pkgs;
  lib = pkgs.lib;

in
{
  inherit (inputs.common) bee;
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "buildbot-server2";
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [ ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB9Yw3xZGGzPfnYSfH1OB8oNbJe/EFutMJ6uSQ7fpQGi'' ];

  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "8.8.8.8"
    ];
    defaultGateway = "172.31.1.1";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "5.161.50.34"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2a01:4ff:f0:b71::1"; prefixLength = 64; }
          { address = "fe80::9400:4ff:fe5e:7ecf"; prefixLength = 64; }
        ];
        ipv4.routes = [{ address = "172.31.1.1"; prefixLength = 32; }];
        ipv6.routes = [{ address = "fe80::1"; prefixLength = 128; }];
      };

    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="96:00:04:5e:7e:cf", NAME="eth0"

  '';




  system.stateVersion = "23.11";


}
