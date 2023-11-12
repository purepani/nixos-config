{
  inputs,
  cell,
}: {
  imports = [
    cell.nixosModules.glances
  ];
  services.glances = {
    enable = true;
  };
}
