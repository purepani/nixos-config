{
  inputs,
  cell,
}: let
  common = {
    bee = rec {
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs;
    };
  };
in
  inputs.hive.findLoad {
    inherit cell;
    inputs = inputs // {inherit common;};
    block = ./.;
  }
