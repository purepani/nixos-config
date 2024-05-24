{
  inputs,
  cell,
}: {
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
  systemd.services.prowlarr.after = ["caddy.target"]; 
  systemd.services.prowlarr.environment.HOME = "/var/empty";
}
