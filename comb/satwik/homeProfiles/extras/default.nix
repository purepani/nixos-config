{ inputs
, cell
, ...
}:
let
  pkgs = cell.nixpkgs.pkgs;
in
{
  home.packages = with pkgs; [
    cell.packages.qt5Packages.slicer3d
    #inputs.optinix.packages.default
    grayjay
    sshfs
    darktable
    distant
    obsidian
    zellij
    bat
    mprocs
    chromium
    #busybox
    reaper
    #bitwarden
    kicad
    protonmail-desktop
    #xclip
    #discord-canary
    #soundux # Currently Depreciated
    cell.packages.qt5Packages.slicer3d
    nfs-utils
    libreoffice-qt6-fresh
    rocmPackages.rocm-smi
    zoom-us
    zotero
    slack
    obs-studio
    rquickshare
    kdePackages.neochat
    kdePackages.kmail
    kdePackages.akonadi
    kdePackages.kmail-account-wizard
    kdePackages.kio-zeroconf
    nixpkgs-review
    nix-update
    inputs.nixpkgs-update.packages.default
    wireplumber
    #helvum
    openssl
    ranger
    linuxConsoleTools
    bash
    gcc
    nerd-fonts.iosevka
    ledger
    fd
    unzip
    libguestfs
    qpwgraph
    #zrythm
    reaper
    godot_4
    prismlauncher
    atlauncher
    musescore
    steam-run
    steamcmd
    xournalpp
    steam-tui
    rclone
    #x2goclient
    cell.nixpkgs.pkgs_stable.remmina
    freerdp3
    vlc
    #(citrix_workspace.override {
    #	extraCerts=[./vmsctx01-hap1009-onprem-varian-com.pem];
    #})
    #citrix_workspace_23_11_0
    cloudcompare
    cachix
    alsa-scarlett-gui
    nix-diff
    nix-tree
  ];
}
