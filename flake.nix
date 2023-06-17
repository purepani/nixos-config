{
  description = "NixOS configuration";


  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-flake.url = "github:jordanisaacs/neovim-flake";
	};
  outputs = inputs @ {
    nixos,
    nixpkgs,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      satwik-lenovo = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
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
