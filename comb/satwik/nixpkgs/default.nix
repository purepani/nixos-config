{ inputs
, cell
,
}:
let
  system = "x86_64-linux";
in
{
  pkgs = (import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "olm-3.2.16"
      ];
    };
    overlays = [
      inputs.neorg-overlay.overlays.default
      inputs.nix-minecraft.overlays.default
      inputs.emacs-overlay.overlays.default
      (final: prev: {
        myEmacs = prev.emacs-unstable-pgtk.pkgs.withPackages (
          epkgs: [ epkgs.treesit-grammars.with-all-grammars epkgs.vterm ]
        );
      })
    ];
  });

  pkgs_stable = import inputs.nixpkgs_stable {
    inherit system;
  };

  pkgs-nixos-unstable = import inputs.nixos-unstable {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };


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
