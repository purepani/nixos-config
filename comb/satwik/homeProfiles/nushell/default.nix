{ inputs, cell }: {
  programs.nushell = {
    enable = true;
    configFile = {
      text = builtins.readFile ./config.nu;
    };
    extraEnv = ''
      	$env.EDITOR = "nvim";
      	'';
  };

}
