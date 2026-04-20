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
        myEmacs =
          let
            unwrapped_emacs = final.emacs-unstable-pgtk.pkgs.withPackages (
              epkgs: [
                epkgs.treesit-grammars.with-all-grammars
                epkgs.vterm
                final.dash
                final.s-search
                final.fswatch
                final.fd
                (final.texliveMedium.withPackages (ps: with ps; [
                  dvisvgm dvipng # for preview and export as html
                  wrapfig amsmath ulem hyperref capt-of
                ]) )
          ]
            );
          in
            unwrapped_emacs;

        terraria-server = prev.terraria-server.overrideAttrs (old: {
          version = "1.4.5.6";
          src = final.fetchurl {
            url = "https://terraria.org/api/download/pc-dedicated-server/terraria-server-${final.terraria-server.urlVersion}.zip";
            hash = "sha256-11xFWsIX/TQ0RIyPglHBNH8IdahcQ4WJ3HG1V3d+kVU";
          };
        });
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
