{
  description = "NixOS configuration";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-flake.url = "github:jordanisaacs/neovim-flake";
    pianoteq.url = "path:/home/satwik/nixos-config/nix-pianoteq7";
    musnix.url = "github:musnix/musnix";

    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";

    hive.url = "github:divnix/hive";
    hive.inputs.nixpkgs.follows = "nixpkgs";

    #nvim-lilypond-suite = {
    #  url = "github:martineausimon/nvim-lilypond-suite";
    #  flake = false;
    #};
  };
  outputs = inputs @ {
    std,
    hive,
    self,
    ...
  }:
    std.growOn {
      inherit inputs;
      cellsFrom = ./comb;
      cellBlocks = with std.blockTypes;
      with hive.blockTypes; [
        nixosConfigurations
        #homeConfigurations
        (functions "nixosProfiles")
        (functions "hardwareProfiles")
      ];
    }
    {
      nixosConfigurations = hive.collect self "nixosConfigurations";
      #homeConfigurations = hive.collect self "homeConfigurations";
    };
}
