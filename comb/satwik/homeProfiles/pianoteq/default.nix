{
  inputs,
  cell,
}: let
  #inherit (inputs) system;
in {
  home.packages = [
    inputs.pianoteq.pianoteq8
    #inputs.nixpkgs.pianoteq.standard-8
  ];
}
