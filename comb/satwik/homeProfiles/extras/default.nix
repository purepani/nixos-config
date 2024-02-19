{
  inputs,
  cell,
  ...
}: let
  pkgs = import inputs.nixpkgs {
    system = inputs.nixpkgs.system;
    config.allowUnfree = true;
  };
in {
  home.packages = with pkgs; [
    vesktop
    reaper
    bitwarden
    kicad
    xclip
    #discord-canary
    #soundux # Currently Depreciated
    zoom-us
    #zotero
    slack
    obs-studio

    wireplumber
    helvum
    openssl
    ranger
    linuxConsoleTools
    rust-analyzer
    bash
    gcc
    nerdfonts
    ledger
    fd
    unzip
    libguestfs
    qpwgraph
    #zrythm
    reaper
    godot_4
    #minecraft
    prismlauncher
    musescore
    #steam-run
    steamcmd
    xournalpp
    steam-tui
    rclone
    x2goclient
    remmina
    vlc
    citrix_workspace
    #cloudcompare
  ];
}
