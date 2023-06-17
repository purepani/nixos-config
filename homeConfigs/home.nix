{
  config,
  pkgs,
  neovim-flake,
  ...
}: let
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
    config = {
    	vim.theme.enable = true;
	};
  };

  customNeovim = neovim-flake.lib.neovimConfiguration {
    modules = [configModule];
    inherit pkgs;
  };
in {
  # Let Home Manager install and manage itself.

  #nix.nixPath = options.nix.nixPath.default ++ [ "nixpkgs-overlays=${nixpkgs-overlays}/overlays.nix" ];
  programs.home-manager.enable = true;

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
    ]
    ++ [customNeovim.neovim];

  imports = [
  ];
}
