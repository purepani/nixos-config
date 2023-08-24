{
  inputs,
  cells,
}: {
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [inputs.nixpkgs.xdg-desktop-portal-kde];
  };
}
