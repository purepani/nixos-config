{
  inputs,
  cell,
  ...
}: let
  pkgs = cell.nixpkgs.pkgs;
in {
  home.packages = with pkgs; [
    reaper
    bitwarden
    kicad
    #xclip
    #discord-canary
    #soundux # Currently Depreciated
    zoom-us
    zotero
    slack
    obs-studio
    rquickshare
    kdePackages.neochat

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
    #reaper
    godot_4
    #minecraft
    prismlauncher
    musescore
    steam-run
    steamcmd
    xournalpp
    steam-tui
    rclone
    #x2goclient
    remmina
    freerdp3
    vlc
    #citrix_workspace
    #cloudcompare
    cachix
    blender-hip
  ];
}
