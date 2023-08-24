{
  inputs,
  cells,
}: let
in
  inputs.hive.findLoad {
    inherit cells inputs;
    block = ./.;
  }
