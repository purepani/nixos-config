{
  inputs,
  cell,
}: let
  inherit (inputs) common;
  inherit (cell) nixosProfiles hardwareProfiles;
  hostname = "satwik";
in {
  inherit (common) bee;
  networking = {inherit hostname;};
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
  ];
}
