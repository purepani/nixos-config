{ inputs, cell }:
let
  pkgs = cell.nixpkgs.pkgs;
in
{
  services.emacs = {
    enable = true;
    package = pkgs.myEmacs;
    install = true;
    startWithGraphical = true;
  };
}
