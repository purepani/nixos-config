{
  inputs,
  cell,
}:
{
laptop=inputs.hive.load {
  inherit cell;
  inherit inputs;
  src = ./laptop;
};
}
