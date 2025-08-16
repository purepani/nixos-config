{ inputs
, cell
,
}:
let
  inherit (cell) nixosProfiles hardwareProfiles;
  inherit (inputs.common.bee) pkgs;
in
{
  inherit (inputs.common) bee;
  programs.dconf.enable = true;
  services.rpcbind.enable = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  programs.nix-ld.enable = true;
  networking.hostName = "satwik-laptop"; # Define your hostname.
  #boot.kernelPackages = pkgs.linuxPackages-rt_latest;
  imports = with nixosProfiles; [
    inputs.home-manager.nixosModules.home-manager
    hardwareProfiles.laptop
    extra
    nix
    desktop
    kdeconnect
    locale
    pipewire
    steam
    #virtualization
    #zerotier-one
    udev
    NetworkManager
    #musnix
    netmaker
    inputs.musnix.nixosModules.musnix
    netbird
    resolved
    qbittorrent
  ];
  home-manager.users.satwik = cell.homeConfigurations.laptop;

  services.qbittorrent2 = {
    enable = true;
    openFirewall = true;
    port = 58080;
  };
  musnix = {
    enable = true;
  };
  networking.nameservers = [
    "1.1.1.1"
    "1.1.1.2"
  ];

  nix = {
    settings = {
      trusted-users = [ "satwik" ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
