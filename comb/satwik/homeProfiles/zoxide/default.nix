{ inputs, cell }:
let

in {
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

}
