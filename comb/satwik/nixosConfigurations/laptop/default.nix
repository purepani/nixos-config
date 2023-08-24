{inputs, cell}:
let 
  inherit (inputs) common nixpkgs;
  inherit (cell) nixosProfiles;
  inherit (nixpkgs) lib;
  hostname = "satwik";
in
  {
    inherit (common) bee;
    networking = {inherit hostname;};
    imports = with nixosProfiles; [
      ./hardware-configuration.nix  
      extra
      nixdesktop
      kdeconnect
      locale
      nix
      pipewire
      steam
      virtualization
      zerotier-one
      ];
  }
