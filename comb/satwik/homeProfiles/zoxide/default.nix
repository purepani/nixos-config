{ inputs, cell }: {
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };
}
