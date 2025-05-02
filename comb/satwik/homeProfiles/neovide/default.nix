{ inputs, cell }:

let
  neovide-config = { config, pkgs, lib, ... }: {

    programs.neovide = {
      enable = true;
      settings = {
        neovim-bin = "${config.programs.nixvim.build.package}/bin/nvim";

      };
    };

  };

in
{

  imports = [
    neovide-config

  ];
}
