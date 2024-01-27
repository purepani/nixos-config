{
  description = "NixOS configuration";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/452b8162ecc995793d906cde424b652fa3dd1314";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-flake.url = "github:jordanisaacs/neovim-flake";
    pianoteq.url = "github:purepani/pianoteq.nix";
    musnix.url = "github:purepani/musnix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";

    hive.url = "github:whs-dot-hk/hive/remove-nixpkgs-config";
    #hive.url = "github:divnix/hive";
    hive.inputs.nixpkgs.follows = "nixpkgs";

    hive.inputs.colmena.url = "github:zhaofengli/colmena";
    colmena.url = "github:zhaofengli/colmena";
    haumea.url = "github:nix-community/haumea";

    std.inputs.devshell.url = "github:numtide/devshell";
    plugin-nvim-lilypond-suite = {
      url = "github:martineausimon/nvim-lilypond-suite";
      flake = false;
    };
  };
  outputs = inputs @ {
    std,
    hive,
    self,
    ...
  }: let
    lib = inputs.nixpkgs.lib // builtins;
  in
    hive.growOn {
      inherit inputs;
      systems = [
        "x86_64-linux"
      ];
      cellsFrom = ./comb;
      nixpkgsConfig.allowUnfreePredicate = pkg:
        lib.elem (lib.getName pkg) [
          "reaper"
          "zoom"
          "slack"
          "discord-canary"
        ];
      cellBlocks = with std.blockTypes;
      with hive.blockTypes; [
        nixosConfigurations
        homeConfigurations
        colmenaConfigurations
        (functions "nixosProfiles")
        (functions "homeProfiles")
        (functions "hardwareProfiles")
        #(installables "package")
        #(functions "module")
        (functions "neovim")
        (functions "nixosModules")
        (installables "packages")

        (devshells "devshells")
      ];
    }
    {
      devShells = hive.harvest self ["repo" "devshells"];
    }
    {
      nixosConfigurations = hive.collect self "nixosConfigurations";
      homeConfigurations = hive.collect self "homeConfigurations";
      colmenaHive = hive.collect self "colmenaConfigurations";
    };
}
