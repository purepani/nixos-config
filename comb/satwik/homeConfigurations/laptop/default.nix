{
  inputs,
  cell,
}: let
  inherit (cell) homeProfiles;
  #inherit (inputs.common) bee;
in {
  bee = rec {
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    home = inputs.home-manager;
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = with homeProfiles; [
    direnv
    easyeffects
    git
    neovim
    pianoteq
    extras
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "satwik";
  home.homeDirectory = "/home/satwik";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwyards
  # incompatible changes.

  home.stateVersion = "23.05";

  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.sessionVariables.EDITOR = "nvim";
}
