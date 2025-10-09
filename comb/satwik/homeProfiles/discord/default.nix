{ inputs
, cell
,
}:
let
  pkgs = cell.nixpkgs.pkgs;
in
{
  home.packages = with pkgs; [
    vesktop
  ];
  services.arrpc.enable = true;
}
