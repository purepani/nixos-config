{
  imports,
  cell,
}: {
  services.sonarr = {
    enable = true;
    openFirewall = true;
  };
}
