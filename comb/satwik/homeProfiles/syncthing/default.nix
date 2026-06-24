{inputs, cell}: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    overrideDevices = false;
    settings = {
      folders = {
        "/home/satwik/org-notes" = {
          
        };
          
      };
    };
  };
}
