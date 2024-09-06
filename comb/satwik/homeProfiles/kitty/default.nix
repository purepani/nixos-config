{ inputs, cell }: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
  };
}
