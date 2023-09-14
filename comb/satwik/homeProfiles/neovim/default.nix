{
  inputs,
  cell,
}: let
  config = {
    build.viAlias = false;
    build.vimAlias = true;
    vim.languages = {
      enableLSP = true;
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      nix.enable = true;
      markdown.enable = true;
      html.enable = true;
      clang.enable = true;
      sql.enable = false;
      rust = {
        enable = true;
        crates.enable = true;
      };
      ts.enable = true;
      go.enable = true;
      zig.enable = true;
      python.enable = true;
      plantuml.enable = true;

      # See tidal config
      tidal.enable = false;
    };
    vim.lsp = {
      formatOnSave = true;
      lspkind.enable = true;
      lightbulb.enable = true;
      lspsaga.enable = false;
      nvimCodeActionMenu.enable = true;
      trouble.enable = true;
      lspSignature.enable = true;
    };
    vim.visuals = {
      enable = true;
      nvimWebDevicons.enable = true;
      indentBlankline = {
        enable = true;
        fillChar = null;
        eolChar = null;
        showCurrContext = true;
      };
      cursorWordline = {
        enable = true;
        lineTimeout = 0;
      };
    };
    vim.statusline.lualine.enable = true;
    vim.theme.enable = true;
    vim.autopairs.enable = true;
    vim.autocomplete = {
      enable = true;
      type = "nvim-cmp";
    };
    vim.filetree.nvimTreeLua.enable = true;
    vim.tabline.nvimBufferline.enable = true;
    vim.treesitter.context.enable = true;
    vim.keys = {
      enable = true;
      whichKey.enable = true;
    };
    vim.telescope.enable = true;
    vim.git = {
      enable = true;
      gitsigns.enable = true;
      gitsigns.codeActions = true;
    };
  };
  module = {inherit config;};
  Neovim = inputs.neovim-flake.lib.neovimConfiguration {
    modules = [module];
    pkgs= inputs.nixpkgs;
  };
in {
  home.packages = [Neovim];
}
