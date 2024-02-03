{
  inputs,
  cell,
}: let
  pkgs = inputs.nixpkgs;
in
  inputs.hive.load {
    src = ./derivations;
    inputs =
      {
        inherit inputs cell;
        deepfilter = cell.packages.deepfilter;
      }
      // (removeAttrs pkgs ["self" "super" "root"]);
    loader = inputs.hive.loaders.callPackage;
    transformer = [inputs.hive.transformers.liftDefault];
  }
