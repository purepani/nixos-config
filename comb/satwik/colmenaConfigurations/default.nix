{
  inputs,
  cell,
}: 
let
common = {
  bee = {
    pkgs = inputs.nixpkgs;
    system = "x86_64-linux";
  };
};
in
  inputs.hive.findLoad {
    inherit cell;
    inputs = inputs // common;
    block = ./.;
  }
