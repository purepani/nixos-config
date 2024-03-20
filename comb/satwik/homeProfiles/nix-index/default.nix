{
  inputs,
  cell,
}: {
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
  };
}
