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
        #config.packageOverrides = pkgs: {
        #  vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
        #};
      };
    };
  };
in
  inputs.hive.findLoad {
    inherit cell;
    inputs = inputs // {inherit common;};
    block = ./.;
  }
