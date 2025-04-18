{ inputs
, cell
,
}:
let
  system = "x86_64-linux";
  common = {
    bee = {
      inherit system;
      pkgs = cell.nixpkgs.pkgs;
    };
  };
in
inputs.hive.findLoad {
  inherit cell;
  inputs = inputs // { inherit common; };
  block = ./.;
}
