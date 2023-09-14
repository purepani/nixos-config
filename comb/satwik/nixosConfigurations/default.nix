{
  inputs,
  cell,
}: let
  system = "x86_64-linux";
  common = {
    bee = {
      inherit system;
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;

        config.packageOverrides = pkgs: {
          vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
        };
        overlays = [
          (final: prev: {
            bazarr = prev.bazarr.overrideAttrs (old: {
              buildInputs =
                [
                  (prev.python3.withPackages (ps: [ps.lxml ps.numpy ps.gevent ps.gevent-websocket ps.pillow ps.setuptools]))
                ]
                ++ [prev.ffmpeg prev.unar];
            });
          })
        ];
      };
    };
  };
in
  inputs.hive.findLoad {
    inherit cell;
    inputs = inputs // {inherit common;};
    block = ./.;
  }
