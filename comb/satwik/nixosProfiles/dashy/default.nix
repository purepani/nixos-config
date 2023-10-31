{
  inputs,
  cell,
}: {
  imports = [cell.nixosModules.dashy];
  services.dashy = {
    enable = true;
    package = cell.packages.dashy;
  };
}
