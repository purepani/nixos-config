{
  inputs,
  cell,
}: let
  common = {
    bee = rec {
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;  
      }; 
      home = inputs.home-manager;
    };
  };
in
  inputs.hive.findLoad {
    inherit cell;
    inputs = inputs // {inherit common;};
    block = ./.;
  }