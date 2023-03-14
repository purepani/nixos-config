{
  config,
  pkgs,
  options,
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
      vim.viAlias = false;
      vim.vimAlias = true;
      vim.lsp = {
        enable = true;
        formatOnSave = true;
        lightbulb.enable = true;
        lspsaga.enable = false;
        nvimCodeActionMenu.enable = true;
        trouble.enable = true;
        lspSignature.enable = true;
        nix = {
          enable = true;
          formatter = "alejandra";
        };
        rust.enable = true;
        python = true;
        clang.enable = true;
        sql = true;
        ts = true;
        go = false;
        zig.enable = true;
      };
      vim.visuals = {
        enable = true;
        nvimWebDevicons.enable = true;
        lspkind.enable = true;
        indentBlankline = {
          enable = true;
          fillChar = "";
          eolChar = "";
          showCurrContext = true;
        };
        cursorWordline = {
          enable = true;
          lineTimeout = 0;
        };
      };
      vim.statusline.lualine = {
        enable = true;
        theme = "onedark";
      };
      vim.theme = {
        enable = true;
        name = "onedark";
        style = "darker";
      };
      vim.autopairs.enable = true;
      vim.autocomplete = {
        enable = true;
        type = "nvim-cmp";
      };
      vim.filetree.nvimTreeLua.enable = true;
      vim.tabline.nvimBufferline.enable = true;
      vim.treesitter = {
        enable = true;
        context.enable = true;
      };
      vim.keys = {
        enable = true;
        whichKey.enable = true;
      };
      vim.telescope = {
        enable = true;
      };
      vim.markdown = {
        enable = true;
        glow.enable = true;
      };
      vim.git = {
        enable = true;
        gitsigns.enable = true;
      };
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
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwyards
  # incompatible changes.

  home.stateVersion = "22.11";

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
      #arduino
      linuxConsoleTools
      rust-analyzer
      #graphviz
      bash
      gcc
      nerdfonts
      ledger
      fd
      unzip
      nodejs
    ]
    ++ [customNeovim.neovim];

  imports = [
  ];
}
