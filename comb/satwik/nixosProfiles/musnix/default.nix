{
  inputs,
  cell,
}: {
  inherit (inputs) bee;
  imports = [
    inputs.musnix.nixosModules.musnix
  ];

  musnix = {
    enable = true;
    kernel.realtime = true;
  };
}
