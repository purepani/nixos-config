{ inputs, cell }: {
  programs.ssh = {
    enable = true;
    addKeysToAgent = "confirm";
    matchBlocks = {
      veneprodigy = {
        user = "satwik";
        hostname = "192.168.1.7";
        identityFile = [ "/home/satwik/.ssh/personal_server" ];
      };
    };
  };
  services.ssh-agent.enable = true;
}
