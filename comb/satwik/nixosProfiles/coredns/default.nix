{
  inputs,
  cell,
}: {
  services.coredns = {
    enable = true;
    config = ''
      . {
        whoami
      }
      veneprodigy.com {
        file /home/satwik/dns/db.veneprodigy.com
        log
      }
    '';
  };
}
