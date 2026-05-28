{inputs, cell}: {
  services.tailscale = {
    enable=true;
    openFirewall = true;
  };
}
