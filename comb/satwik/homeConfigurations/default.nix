{
  inputs,
  cell,
}:
inputs.hive.findLoad {
  inherit cell;
  inherit inputs;
   block = ./.;
}
