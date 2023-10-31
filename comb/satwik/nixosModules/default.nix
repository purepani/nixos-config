{
  inputs,
  cell,
}:
inputs.hive.findLoad {
  inherit inputs cell;
  block = ./.;
  #loader = inputs.hive.loaders.verbatim;
}
