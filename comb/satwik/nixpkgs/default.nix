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
      #inputs.neovim-nightly-overlay.overlays.default 	
      #inputs.nixos-cosmic.overlays.default
      inputs.neorg-overlay.overlays.default
      inputs.nix-minecraft.overlays.default
      # TODO: remove after nixpkgs update
      (final: prev: {
        kdePackages = prev.kdePackages.overrideScope (
          qt6Final: qt6Prev: {
            libquotient = qt6Prev.libquotient.overrideAttrs
              (old: {
                version = "0.9.5";
                src = final.fetchFromGitHub {
                  owner = "quotient-im";
                  repo = "libQuotient";
                  rev = "0.9.5";
                  hash = "sha256-wdIE5LI4l3WUvpGfoJBL8sjBl2k8NfZTh9CjfJc9FIA=";
                };
                patches = [
                  (final.fetchpatch {
                    url = "https://github.com/quotient-im/libQuotient/commit/6d5a80ddaab5803c318240c7978a16fbdc36bb34.patch";
                    hash = "sha256-JMdcywGgZ0Gev/Nce4oPiMJQxTBJYPoq+WoT3WLWWNQ=";
                  })
                ];
              });
          }
        );
      })
      #inputs.fenix.overlays.default
      #(final: prev: {
      #	vaapiIntel = prev.vaapiIntel.override {enableHybridCodec = true;};
      #})
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
