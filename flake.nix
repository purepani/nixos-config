{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-flake.url = "github:jordanisaacs/neovim-flake";
    wslpath = {
      url = "github:laurent22/wslpath";
      flake = false;
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:msteen/nixos-vscode-server";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nixos-wsl,
    vscode-server,
    ...
  }: {
    nixosConfigurations = {
      satwik-lenovo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          nixos-wsl.nixosModules.wsl
          vscode-server.nixosModule
          ({
            config,
            pkgs,
            ...
          }: {
            services.vscode-server.enable = true;
          })
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nixos = import ./homeConfigs/home.nix;

            home-manager.extraSpecialArgs = inputs;
          }
        ];
      };
    };
  };
}
