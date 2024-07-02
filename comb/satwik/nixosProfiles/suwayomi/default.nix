{inputs, cell}: 
{
	services.suwayomi-server = {
		enable = true;
		#dataDir = "/media/manga";
		openFirewall = true;
		settings = {
			server = {
				ip = "127.0.0.1";
				port = 8080;
			};
		};
	};
}
