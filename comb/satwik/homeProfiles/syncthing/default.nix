{inputs, cell}: {
  services.syncthing = {
    enable = true;
    overrideDevices = false;
    tray.enable = true;
    settings = {
      folders = {
        "~/org-notes" = {
          
        };
          
      };
    };
  };
}
