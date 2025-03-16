{ inputs, cell }: {
  programs.nushell = {
    enable = true;
    configFile = {
      text = builtins.readFile ./config.nu;
    };
    extraEnv = ''
      	$env.SHELL="nu";
      	$env.EDITOR = "nvim";
      	'';
  };

}
