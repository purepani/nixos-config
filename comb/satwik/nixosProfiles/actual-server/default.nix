{
  inputs,
  cell,
}: {
  services.actual = {
    enable = true;
    openFirewall = true;
    settings = {
    	port=5006;
    	config = {
		serverFiles = "/data/server-files";
		userFiles = "/data/user-files";
		dataDir = "/data";
	};
    };
  };
}
