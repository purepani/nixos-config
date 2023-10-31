{
  inputs,
  cell,
}:
inputs.haumea.lib.load {
  src = ./.;
  inputs = {
    inherit inputs cell;
  };
  loader = inputs.hive.loaders.callPackage;
}
