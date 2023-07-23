{
  config,
  pkgs,
  neovim-flake,
  pianoteq,
  ...
}: let
  system = "x86_64-linux";
  customPylsp = pkgs.python39Packages.python-lsp-server.override {
    withAutopep8 = true;
    withFlake8 = true;
    withMccabe = true;
    withPycodestyle = true;
    withPydocstyle = true;
    withPyflakes = true;
    withPylint = true;
    withRope = true;
    withYapf = true;
  };

  configModule = {
    # Add any custom options (and feel free to upstream them!)
    # options = ...
    #config.build.rawPlugins = {nvim-lilypond-suite = {src = nvim-lilypond-suite;};};
  };

  maximalNeovim = neovim-flake.packages.${system}.maximal;
  #Neovim = neovim-flake.lib.neovimConfiguration.extendConfiguration {
  #  modules = [configModule];
  #};
  Neovim = maximalNeovim;
in {
  # Let Home Manager install and manage itself.

  programs.home-manager.enable = true;

  services.easyeffects = {
    enable = true;
    package = pkgs.easyeffects.override {
      speexdsp = pkgs.speexdsp.overrideAttrs (old: {configureFlags = [];});
    };
  };
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
  programs.git = {
    enable = true;
    userName = "purepani";
    userEmail = "pani0028@umn.edu";
  };
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      eval "$(direnv hook bash)"
    '';
  };
  home.packages = with pkgs;
    [
      kicad
      xclip
      discord
      soundux
      zoom
      zotero
      slack
      obs-studio

      #teams
      zoom
      wireplumber
      helvum
      webcord
      openssl
      ranger
      linuxConsoleTools
      rust-analyzer
      bash
      gcc
      nerdfonts
      ledger
      fd
      unzip
      libguestfs
      qpwgraph
      zrythm
      reaper
      godot_4
      minecraft
      prismlauncher
      musescore
    ]
    ++ [Neovim pianoteq.packages.x86_64-linux.default];

  imports = [
  ];
}
