{ inputs, cell }: {
  programs.kitty.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {

      monitor = [
        "DP-1, preferred, auto, 1"
        "HDMI-A-1, preferred, auto-right, 1"
        "DP-3, preferred, auto-left, 1"
      ];
    };
  };

} 
