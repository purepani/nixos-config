{
  inputs,
  cell,
}: let
  inherit (inputs) common;
  inherit (cell) nixosProfiles hardwareProfiles;
  inherit (common) bee;
  inherit (bee) pkgs;
in {
  inherit bee;
programs.dconf.enable=true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  imports = with nixosProfiles; [
    hardwareProfiles.laptop
    extra
    nix
    desktop
    kdeconnect
    locale
    nix
    pipewire
    steam
    virtualization
    zerotier-one
    udev
  ];
}
