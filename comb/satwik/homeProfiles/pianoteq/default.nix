{ inputs
, cell
,
}:
let
  #inherit (inputs) system;
in
{
  home.packages = [
    inputs.pianoteq.pianoteq9
    #inputs.nixpkgs.pianoteq.standard-8
  ];
}
