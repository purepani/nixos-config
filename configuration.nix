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
  wslpath-env = pkgs.stdenv.mkDerivation {
    name = "wslpath-1.0";
    src = wslpath;

    installPhase = ''
      mkdir -p $out/usr/bin
      cp wslpath $out/usr/bin/
      chmod 755 $out/usr/bin/wslpath
    '';

    buildInputs = [pkgs.php];
  };
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
    nativeSystemd = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
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
