{
  inputs,
  cell,
}: let
in
  inputs.hive.findLoad {
    inherit cell inputs;
    block = ./.;
  }
