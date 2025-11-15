{ inputs, cell }:
{
  services.udev = {
    enable = true;
    extraRules = ''
      KERNEL=="ttyUSB*", MODE="0666"
      ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="2dc8", DRIVERS=="usb", ATTR{power/wakeup}="enabled"
    '';
  };

}
