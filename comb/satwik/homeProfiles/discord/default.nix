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
    discord-canary
  ];
  services.arrpc.enable = true;
}
