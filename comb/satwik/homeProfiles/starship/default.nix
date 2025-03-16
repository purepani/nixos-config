{ inputs, cell }: {
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
}
