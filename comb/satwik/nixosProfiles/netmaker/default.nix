{
  inputs,
  cell,
}: {
  services.netclient.enable = true;
  environment.etc.hosts.mode = "0644";
}
