
{
  inputs,
  cell,
}: {

  services.jitsi-meet = {
    enable = false;
    hostName = "jitsi.veneprodigy.com";
    caddy.enable=true;
    nginx.enable=false;
  };
  services.jitsi-videobridge.openFirewall = true;
}
