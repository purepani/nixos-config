{ inputs, cell }: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
                                  return {
                        	      	front_end = "WebGpu",
                  			font_size = 8.0,
      				font = wezterm.font ('Iosevka Nerd Font'),
                        		window_padding = {
            				left = 0,
            				right = 0,
            				top = 0,
            				bottom=0,
            			},
            			window_frame = {
            				font_size=8.0,
            			},
                                  }
            			
    '';
  };
}
