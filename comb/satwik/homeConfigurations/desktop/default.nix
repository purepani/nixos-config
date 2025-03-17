{ inputs
, cell
,
}:
let
  inherit (cell) homeProfiles;
  #inherit (inputs.common) bee;
  pkgs = cell.nixpkgs.pkgs;

  system = "x86_64-linux";
  #bee = rec {
  #  system = "x86_64-linux";
  #  pkgs = cell.nixpkgs.pkgs;
  #  home = inputs.home-manager;
  #};
in
{
  #inherit bee;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.fish.enable = false;

  home.packages = with pkgs; [ blender-hip ];

  imports = with homeProfiles; [
    eza
    fontconfig
    direnv
    hyprland
    nushell
    easyeffects
    rust
    git
    discord
    ssh
    jujutsu
    zoxide
    wezterm
    kitty
    neovim
    starship
    #fluidsynth
    pianoteq
    lilypond
    extras
    nix-index
    xdg
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "satwik";
  home.homeDirectory = "/home/satwik";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwyards
  # incompatible changes.
  home.keyboard = null;

  home.stateVersion = "23.05";

  manual = {
    manpages.enable = true; # causes error
    html.enable = false; # saves space
    json.enable = false; # don't know what to do with this
  };
  targets.genericLinux.enable = true;
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.shell.enableShellIntegration = true;
  home.shellAliases = { };

  home.sessionVariables = {
    SHELL = "nu";
    EDITOR = "nvim";
    TERM = "wezterm";
    #TODO: Remove when https://github.com/jj-vcs/jj/issues/4745 is fixed
    LESS = "FRX";
  };
}
