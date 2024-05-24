{imports, cell}:
{
  services.radarr = {
    enable=true;
    openFirewall=true;
  };

  systemd.services.radarr.after = ["caddy.target"];
}
