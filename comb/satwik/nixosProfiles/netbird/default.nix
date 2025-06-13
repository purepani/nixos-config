{ inputs
, cells
,
}: {
  services.netbird.clients.default = {
    port = 51820;
    name = "netbird";
    interface = "wt0";
    hardened = false;
    dns-resolver.port = 5053;
  };
}
