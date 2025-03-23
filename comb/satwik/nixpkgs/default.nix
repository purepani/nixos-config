{ inputs
, cell
,
}:
let
  system = "x86_64-linux";
in
{
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "olm-3.2.16"
      ];
    };
    overlays = [
      #inputs.neovim-nightly-overlay.overlays.default 	
      inputs.neorg-overlay.overlays.default
      inputs.nix-minecraft.overlays.default
      inputs.fenix.overlays.default
      #(final: prev: {
      #	vaapiIntel = prev.vaapiIntel.override {enableHybridCodec = true;};
      #})
    ];
  };

  pkgs_rocm = import inputs.nixpkgs_rocm { inherit system; };
  pkgs_unstable_small = import inputs.nixos_unstable_small {
    inherit system;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "olm-3.2.16"
      ];
    };
    overlays = [
      #inputs.neovim-nightly-overlay.overlays.default 	
      inputs.neorg-overlay.overlays.default
      inputs.nix-minecraft.overlays.default
      #inputs.fenix.overlays.default
      #(final: prev: {
      #	vaapiIntel = prev.vaapiIntel.override {enableHybridCodec = true;};
      #})
    ];
  };
}
