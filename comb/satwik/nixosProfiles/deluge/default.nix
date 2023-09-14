{
  inputs,
  cell,
}: {
  services.deluge = {
    enable = true;
    openFirewall = true;
    #declarative = true;
    #authFile = /run/keys/deluge-auth;
    web = {
      enable = true;
      openFirewall = true;
    };
  };
}
