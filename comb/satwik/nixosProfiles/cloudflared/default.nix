{ inputs, cell }: {
  services.cloudflared = {
    enable = true;
    credentialsFile = "/home/satwik/.cloudflared/cert.pem";
    tunnels.external-tunnel = {
      credentialsFile = "/home/satwik/.cloudflared/04a959fc-1576-4889-a2b0-79f9de1cc572.json";
      default = "http_status:404";
      ingress = {
        "rocketriders.veneprodigy.com" = "127.0.0.1:25565";
      };
    };

  };
}
