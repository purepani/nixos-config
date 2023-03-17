{
  description = "Home Manager configuration of Satwik";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-flake.url = "github:jordanisaacs/neovim-flake";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ attrs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    homeConfigurations.nixos = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        ./home.nix
      ];
      extraSpecialArgs = attrs;
      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };
  };
}
