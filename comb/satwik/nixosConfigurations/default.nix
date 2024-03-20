{
  inputs,
  cell,
}: let
  system = "x86_64-linux";
  nixpkgs-patched = (import inputs.nixpkgs {inherit system;}).applyPatches {
    name = "nixpkgs-patched-13145";
    src = inputs.nixpkgs;
    patches = [
      (inputs.nixpkgs.fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/286522.patch";
        hash = "sha256-gKR+/liurhuaRPk2PTit5sqEdvBIERZWhjjHna/Nfyg=";
      })
    ];
  };
  common = {
    bee = {
      inherit system;
      pkgs = cell.nixpkgs.pkgs;
    };
  };
in
  inputs.hive.findLoad {
    inherit cell;
    inputs = inputs // {inherit common;};
    block = ./.;
  }
