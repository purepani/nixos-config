{
  inputs,
  cell,
}: {
  imports = [cell.nixosModules.actual-server];
  services.actual-server = {
    enable = true;
    package = cell.packages.actualbudget.package;
  };
  networking.firewall = {
    # from https://jellyfin.org/docs/general/networking/index.html
    allowedTCPPorts = [5006];
    allowedUDPPorts = [5006];
  };
}
