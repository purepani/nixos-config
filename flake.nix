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
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";

    hive.url = "github:divnix/hive";
    hive.inputs.nixpkgs.follows = "nixpkgs";

    hive.inputs.colmena.url = "github:zhaofengli/colmena";
    colmena.url = "github:zhaofengli/colmena";

    std.inputs.devshell.url = "github:numtide/devshell";
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
    hive.growOn {
      inherit inputs;
      systems = [
        "x86_64-linux"
      ];
      cellsFrom = ./comb;
      nixpkgsConfig = {
        allowUnfree = true;
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
      cellBlocks = with std.blockTypes;
      with hive.blockTypes; [
        nixosConfigurations
        homeConfigurations
        colmenaConfigurations
        (functions "nixosProfiles")
        (functions "homeProfiles")
        (functions "hardwareProfiles")

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
