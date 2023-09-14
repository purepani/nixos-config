{
  inputs,
  cell,
}: {
  services.bazarr = {
    enable = true;
    openFirewall = true;
  };
}
