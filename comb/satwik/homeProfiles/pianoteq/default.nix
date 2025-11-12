{ inputs
, cell
,
}:
let
  #inherit (inputs) system;
in
{
  home.packages = [
    inputs.pianoteq.packages.pianoteq_v9
    #inputs.nixpkgs.pianoteq.standard-8
  ];
}
