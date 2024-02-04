{
  inputs,
  cell,
}: let
  inherit (cell) homeProfiles;
  #inherit (inputs.common) bee;
  bee = rec {
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {
      inherit system;

      config.allowUnfree = true;
      overlays = [
      ];
    };
    home = inputs.home-manager;
  };
in {
  inherit bee;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = with homeProfiles; [
    direnv
    easyeffects
    git
    neovim
    fluidsynth
    pianoteq
    lilypond
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

  manual = {
    manpages.enable = false; # causes error
    html.enable = false; # saves space
    json.enable = false; # don't know what to do with this
  };
  targets.genericLinux.enable = true;
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.sessionVariables.EDITOR = "nvim";
}
