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
        deepfilter = cell.packages.deepfilter.package;
      }
      // (removeAttrs pkgs ["self" "super" "root"]);
    loader = inputs.hive.loaders.callPackage;
  }
