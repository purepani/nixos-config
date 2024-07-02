{inputs, cell}: {

	imports = [
		inputs.nix-minecraft.nixosModules.minecraft-servers
	];
	services.minecraft-servers = {
		enable = true;
		openFirewall = true;
		eula = true;
		servers = {
			"rocket-riders" = {
				enable = true;
				autoStart = true;
				serverProperties = {
					server-port = 25565;
					motd = "PB Rocket Riders";
					openFirewall = true;
				};
			};
		};	
	};
}
