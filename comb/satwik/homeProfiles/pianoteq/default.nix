{
  inputs,
  cell,
}: let
  inherit (inputs) system;
in {
  home.packages = [inputs.pianoteq.pianoteq8];
}
