{
  description = "NixOS configuration";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-old.url = "github:nixos/nixpkgs/700db686fdd9bab4829b1413db8c223e79f4c9f0";
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
    sops-nix.url = "github:Mic92/sops-nix";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    pianoteq.url = "github:purepani/pianoteq.nix";
    musnix.url = "github:purepani/musnix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    authentik-nix. url = "github:nix-community/authentik-nix";
    nixvim = {
    	url = "github:nix-community/nixvim";
	inputs.nixpkgs.follows = "nixpkgs";
	};


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
        (functions "nixpkgs")
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
      packages = std.harvest self ["satwik" "packages"];

      nixConfig = {
        extra-substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos.org/"
        ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };
}
