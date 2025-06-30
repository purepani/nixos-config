{ inputs, cell }: {
  services.cloudflared = {
    enable = true;
    certificateFile = "/home/satwik/.cloudflared/cert.pem";
    tunnels.external-tunnel = {
      credentialsFile = "/home/satwik/.cloudflared/04a959fc-1576-4889-a2b0-79f9de1cc572.json";
      default = "http_status:404";
      ingress = {
        "veneprodigy.com" = "https://127.0.0.1:9010";
      };
    };

  };
}
