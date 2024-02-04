{
  inputs,
  cell,
}: let
  inherit (cell) nixosProfiles hardwareProfiles;
  inherit (inputs.common.bee) pkgs;
in {
  inherit (inputs.common) bee;
  programs.dconf.enable = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.kernelPackages = pkgs.linuxPackages-rt_latest;
  security.sudo.enable = true;
  imports = with nixosProfiles; [
    hardwareProfiles.desktop
    nfs
    extra
    nix
    desktop
    kdeconnect
    locale
    pipewire
    steam
    virtualization
    zerotier-one
    udev
    NetworkManager
    #musnix
    netmaker
    inputs.musnix.nixosModules.musnix
    netbird
    resolved
  ];

  hardware.opengl = {
    enable = true;
  };
  musnix = {
    enable = true;
  };
  networking.nameservers = [
    "1.1.1.1"
    "1.1.1.2"
  ];
  security.pam.services = {
    openconnect = {
      u2fAuth = true;
    };
  };

  programs.nix-ld.enable = true;
  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "eno1";
    #externalInterface = "wlp8s0";
    # Lazy IPv6 connectivity for the container
  };

  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  environment.etc = let
    json = pkgs.formats.json {};
  in {
    "pipewire/pipewire.d/91-null-sinks.conf".source = json.generate "91-null-sinks.conf" {
      context.objects = [
        {
          # A default dummy driver. This handles nodes marked with the "node.always-driver"
          # properyty when no other driver is currently active. JACK clients need this.
          factory = "spa-node-factory";
          args = {
            factory.name = "support.node.driver";
            node.name = "Dummy-Driver";
            priority.driver = 8000;
          };
        }
        {
          factory = "adapter";
          args = {
            factory.name = "support.null-audio-sink";
            node.name = "Microphone-Proxy";
            node.description = "Microphone";
            media.class = "Audio/Source/Virtual";
            audio.position = "MONO";
          };
        }
        {
          factory = "adapter";
          args = {
            factory.name = "support.null-audio-sink";
            node.name = "pipewire";
            node.description = "Main Output";
            media.class = "Audio/Sink";
            audio.position = "FL,FR";
          };
        }
      ];
    };
  };
}
