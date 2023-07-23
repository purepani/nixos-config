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
    #nvim-lilypond-suite = {
    #  url = "github:martineausimon/nvim-lilypond-suite";
    #  flake = false;
    #};
  };
  outputs = inputs @ {
    nixos,
    nixpkgs,
    home-manager,
    musnix,
    ...
  }: {
    nixosConfigurations = {
      satwik-lenovo = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          musnix.nixosModules.musnix
          {
            musnix.enable = true;
            musnix.kernel.realtime = false;
          }

          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.satwik = import ./homeConfigs/home.nix;

            home-manager.extraSpecialArgs = inputs;
          }
        ];
      };
    };
  };
}
