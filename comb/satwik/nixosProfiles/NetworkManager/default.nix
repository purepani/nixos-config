{
  inputs,
  cell,
}: let
  pkgs = inputs.nixpkgs;
in {
  networking.networkmanager = {
    enable = true;
    plugins = [
      pkgs.networkmanager-openconnect
    ];
  };
}
