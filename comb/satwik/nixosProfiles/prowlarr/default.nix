{
  inputs,
  cell,
}: {
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
}
