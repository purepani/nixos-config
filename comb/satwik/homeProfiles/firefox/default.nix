{ inputs, cell }: {
  programs.firefox = {
    enable = true;
    package = cell.nixpkgs.pkgs.firefox.override {
      cfg = {
        enablePlasmaBrowserIntegration = true;
      };
    };
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          network.protocol-handler.expose.obsidian = false;
        };

      };
    };
  };
}
