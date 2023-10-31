{
 pkgs,
  lib,
  config,
  ...
}:
with lib; {
  config = {
    build.rawPlugins = lib.plugins.fromInputs inputs "plugin-";
    vim.luaConfigRC.autopairs = nvim.dag.entryAnywhere ''
      require('nvls').setup({
      })
    '';
  };
}
