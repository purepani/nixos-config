{
  inputs,
  cell,
}: let
  system = "x86_64-linux";

  patched = (import inputs.nixpkgs {inherit system;}).applyPatches {
    name = "nixpkgs-patched-286522";
    src = inputs.nixpkgs;
    patches = [
      (inputs.nixpkgs.fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/286522.patch";
        hash = "sha256-E9oKjgCUVKggGBP3rb0asrbrvOPhmdj6xET4JsRUf2E=";
      })
    ];
  };
in {
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        cloudcompare = prev.cloudcompare.overrideAttrs (old: {
          nativeBuildInputs = old.nativeBuildInputs ++ [prev.copyDesktopItems];
          desktopItems = [
            (prev.makeDesktopItem {
              name = "CloudCompare";
              exec = "cloudcompare";
              icon = "cc_icon_256";
              comment = old.meta.description;
              desktopName = "CloudCompare";
              genericName = "CloudCompare";
              categories = ["Graphics"];
            })

            (prev.makeDesktopItem {
              name = "CloudCompare Viewer";
              exec = "ccViewer";
              icon = "cc_viewer_icon_256";
              comment = old.meta.description;
              desktopName = "CloudCompare Viewer";
              genericName = "CloudCompare Viewer";
              categories = ["Graphics"];
            })
          ];
          postInstall = ''
            install -Dm444 $src/qCC/images/icon/{cc_viewer,cc}_icon_256.png -t $out/share/icons/hicolor/256x256/apps
            copyDesktopItems
          '';
        });
      })
    ];
  };
}
