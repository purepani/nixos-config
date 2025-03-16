{ inputs, cell }: {
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    colors = "auto";
    icons = "auto";
  };
}
