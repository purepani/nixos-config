{
  inputs,
  cell,
}: {
  imports = [cell.nixosModules.actual-server];
  services.actual-server = {
    enable = true;
    package = cell.packages.actualbudget;
    #userFiles = "/data";
  };
  networking.firewall = {
    allowedTCPPorts = [5006];
    allowedUDPPorts = [5006];
  };
}
