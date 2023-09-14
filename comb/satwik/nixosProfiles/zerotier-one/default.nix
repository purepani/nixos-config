{
  inputs,
  cell,
}: {
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "e5cd7a9e1cefda64"
      "abfd31bd47f65d7b"
    ];
  };
}
