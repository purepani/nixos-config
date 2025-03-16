{ inputs, cell }: {
  programs.eza = {
    enable = true;
    enableBashInegration = true;
    enableNushellIntegration = true;
    colors = "auto";
    icons = "auto";
  };
}
