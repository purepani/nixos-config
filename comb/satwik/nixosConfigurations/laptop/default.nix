{
  inputs,
  cell,
}: let
  inherit (inputs) common;
  inherit (cell) hardwareProfiles nixosProfiles;
  hostName = "satwik";
in {
  inherit (common) bee;
  networking = {inherit hostName;};
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
