{
  inputs,
  cell,
}: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  systemd.services.jellyfin.after = ["caddy.target"];
}
