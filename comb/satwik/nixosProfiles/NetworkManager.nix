{
  inputs,
  cell,
}: let
  #pkgs = inputs.nixpkgs;
in {pkgs, ...}: {
  networking.networkmanager = {
    enable = true;
    plugins = [
      pkgs.networkmanager-openconnect
    ];
  };
}
