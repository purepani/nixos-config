{
  inputs,
  cell,
}: 
let
  inherit (inputs) bee;
in
{
  Neovim = inputs.neovim-flake.packages.${bee.system}.maximal;
}
