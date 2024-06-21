{inputs, cell}: 
{
	services.suwayomi-server = {
		enable = true;
		dataDir = "/media/manga";
		openFirewall = true;
	};
}
