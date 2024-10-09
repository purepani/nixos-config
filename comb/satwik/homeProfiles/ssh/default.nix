{ inputs, cell }:
let
  pkgs = cell.nixpkgs.pkgs;
  askPassword = "${pkgs.systemd}/bin/systemd-ask-password";
  askPasswordWrapper = pkgs.writeScript "ssh-askpass-wrapper"
    ''
      #! ${pkgs.runtimeShell} -e
      export DISPLAY="$(systemctl --user show-environment | ${pkgs.gnused}/bin/sed 's/^DISPLAY=\(.*\)/\1/; t; d')"
      export XAUTHORITY="$(systemctl --user show-environment | ${pkgs.gnused}/bin/sed 's/^XAUTHORITY=\(.*\)/\1/; t; d')"
      export WAYLAND_DISPLAY="$(systemctl --user show-environment | ${pkgs.gnused}/bin/sed 's/^WAYLAND_DISPLAY=\(.*\)/\1/; t; d')"
      exec ${askPassword} "$@"
    '';
in
{
  #programs.ssh = {
  #  enable = true;
  #  addKeysToAgent = "confirm";
  #  matchBlocks = {
  #    veneprodigy = {
  #      user = "satwik";
  #      hostname = "192.168.1.7";
  #      identityFile = [ "/home/satwik/.ssh/personal_server" ];
  #    };
  #  };
  #};
  #services.ssh-agent.enable = true;
  #systemd.user.services.ssh-agent = {
  #  environment.SSH_ASKPASS = askPasswordWrapper;
  #  environment.DISPLAY = "fake";
  #};



}
