
{inputs, cell}:
{
    home.packages = with inputs.nixpkgs;
      [
        kicad
        xclip
        discord
        soundux
        zoom-us
        zotero
        slack
        obs-studio

        teams
        wireplumber
        helvum
        webcord
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
        zrythm
        reaper
        godot_4
        minecraft
        prismlauncher
        musescore
        steam-run
        steamcmd
        xournalpp
        steam-tui
        rclone
        x2goclient
        vlc
      ];
}
