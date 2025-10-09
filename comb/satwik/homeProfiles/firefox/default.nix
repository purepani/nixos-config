{ inputs, cell }: {
  programs.firefox = {
    enable = true;
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
