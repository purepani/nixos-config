{
  imports,
  cell,
}: {
  services.sonarr = {
    enable = true;
    #package = cell.packages.sonarr;
    openFirewall = true;
  };

  systemd.services.sonarr.after = ["caddy.target"];
}
