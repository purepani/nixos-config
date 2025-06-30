{ inputs, cell }:
let
  pkgs = cell.nixpkgs.pkgs;
in
{
  services.boinc = {
    enable = true;
    extraEnvPackages = with pkgs; [
      virtualbox
      ocl-icd
      rocmPackages.clr.icd
    ];
  };
}

