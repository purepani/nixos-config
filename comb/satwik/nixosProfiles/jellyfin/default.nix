{
  inputs,
  cell,
}: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
