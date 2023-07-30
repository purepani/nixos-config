{
  inputs,
  cell
}: let
  name = "Satwik Pani";
  # email = "dgx.arnold@gmail.com";
  # gitSigningKey = "AB15A6AF1101390D";
  email = "pani0028@umn.edu";
  gitSigningKey = "0318D822BAC965CC";

  programs = {
    git = {
      userName = name;
      userEmail = email;
      signing = {
        key = gitSigningKey;
        signByDefault = true;
      };
    };
  };
  home = rec {
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";
    username = "satwik";
  };
  manual = {
    manpages.enable = false; # causes error
    html.enable = false; # saves space
    json.enable = false; # don't know what to do with this
  };
  bee = {
    system = "x86_64-linux";
    inherit (inputs) home;
    pkgs = inputs.nix;
    home = inputs.home-manager;
  };
 
in {

  satwik = {pkgs, system,  ...}: 
	let
	  Neovim = inputs.neovim-flake.packages.${system}.maximal;
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
  };
}
