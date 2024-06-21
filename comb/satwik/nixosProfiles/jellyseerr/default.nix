{
  inputs,
  cell,
}: {
	services.jellyseerr = {
		enable = true;
		openFirewall = true;
	};
}
