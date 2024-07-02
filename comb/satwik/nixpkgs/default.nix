{
  inputs,
  cell,
}: let
  system = "x86_64-linux";
in {
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      inputs.neovim-nightly-overlay.overlays.default 	
      inputs.neorg-overlay.overlays.default
      inputs.nix-minecraft.overlays.default
      #(final: prev: {
      #	vaapiIntel = prev.vaapiIntel.override {enableHybridCodec = true;};
      #})
    ];
  };
}
