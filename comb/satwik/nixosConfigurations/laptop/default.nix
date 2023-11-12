{
  inputs,
  cell,
}: let
  inherit (cell) nixosProfiles hardwareProfiles;
  inherit (inputs.common.bee) pkgs;
in {
  inherit (inputs.common) bee;
  programs.dconf.enable = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages-rt_latest;
  imports = with nixosProfiles; [
    hardwareProfiles.laptop
    extra
    nix
    desktop
    kdeconnect
    locale
    pipewire
    steam
    virtualization
    zerotier-one
    udev
    NetworkManager
    #musnix
    netmaker
    inputs.musnix.nixosModules.musnix
    netbird
    resolved
  ];
  musnix = {
    enable = true;
  };
  networking.nameservers = [
    "1.1.1.1"
    "1.1.1.2"
  ];
}
