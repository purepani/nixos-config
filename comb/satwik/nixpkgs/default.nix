{
  inputs,
  cell,
}: let
  system = "x86_64-linux";

  patched = (import inputs.nixpkgs {inherit system;}).applyPatches {
    name = "nixpkgs-patched-302442";
    src = inputs.nixpkgs;
    patches = [
      (inputs.nixpkgs.fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/302442.patch";
        hash = "sha256-s6GwYpvPgH5V1VrkqeCVgEr8+Y67nP5YmO2H74JZsC0=";
      })
    ];
  };
in {
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      inputs.neovim-nightly-overlay.overlay 	
      inputs.neorg-overlay.overlays.default
    ];
  };
}
