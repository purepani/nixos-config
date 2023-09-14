{inputs, cell}:
{
  services.udev = {
    enable = true;
    extraRules = ''
      KERNEL=="ttyUSB*", MODE="0666"
    '';
  };

}
