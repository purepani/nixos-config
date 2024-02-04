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
        overlays = [
          #(final: prev: {
          #  steam = prev.steam.override ({extraPkgs ? pkgs': [], ...}: {
          #    extraPkgs = pkgs':
          #      (extraPkgs pkgs')
          #      ++ (with pkgs'; [
          #        libxml2
          #      ]);
          #  });
            #vaapiIntel = prev.vaapiIntel.override {enableHybridCodec = true;};
          #})
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
