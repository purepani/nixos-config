{
  inputs,
  cell,
}: {
  home.packages = [ inputs.neovim-flake.packages.x86_64-linux.maximal];
}
