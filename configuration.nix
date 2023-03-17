{
  lib,
  pkgs,
  config,
  modulesPath,
  wslpath,
  #  nixos-wsl,
  ...
}:
with lib; let
  #nixos-wsl = import ./nixos-wsl;
  wslpath-env =
    pkgs.writeScriptBin
    "wslpath"
    (builtins.replaceStrings ["/usr/bin/php"] ["${pkgs.php}/bin/php"] (builtins.readFile "${wslpath}/wslpath"));
in {
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    #   nixos-wsl.nixosModules.wsl

    ./nix-ld-config.nix
  ];

  wsl = {
    enable = true;

    wslConf.automount.root = "/mnt";
    defaultUser = "nixos";
    startMenuLaunchers = true;
    nativeSystemd = false;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  environment.systemPackages = [
    pkgs.php
    pkgs.vim
    pkgs.neovim
    pkgs.wget
    wslpath-env
  ];

  programs.neovim.defaultEditor = true;
  programs.nix-ld.enable = true;

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      allow-import-from-derivation = true
    '';
  };
  system.stateVersion = "22.11";
}
