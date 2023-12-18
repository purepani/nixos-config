{
  inputs,
  cell,
}: let
  pkgs = inputs.nixpkgs;
in
  inputs.hive.load {
    src = ./.;
    inputs =
      {
        inherit inputs cell;
        inherit (cell.packages) deepfilter;
      }
      // (removeAttrs pkgs ["self" "super" "root"]);
    loader = inputs.hive.loaders.callPackage;
  }
