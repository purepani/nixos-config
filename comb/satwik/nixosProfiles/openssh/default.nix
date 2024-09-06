{inputs, cell}:
{
services.openssh = {
  enable = true;
  # require public key authentication for better security
  openFirewall=true;
  settings = { 
#	  PasswordAuthentication = false;
#	  KbdInteractiveAuthentication = false;
#	  PermitRootLogin = "yes";
	  PrintMotd = true;
	};
  };
  users.motd = "Purewater's server.";
}
