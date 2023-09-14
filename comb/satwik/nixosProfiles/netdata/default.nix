{
  inputs,
  comb,
}: {
  services.netdata = {
    enable = true;
    config = {
      web = {
        "allow connections from" = "*";
      };
    };
  };
}
