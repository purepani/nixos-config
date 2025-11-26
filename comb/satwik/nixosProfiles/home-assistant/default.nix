{ inputs, cell }:
{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"
      "homeassistant_hardware"
      "nmap_tracker"
      "mqtt"
      "google"
      "nest"
      #"zha"
    ];
    extraPackages = ps: with ps; [
      grpcio
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      "automation ui" = "!include automations.yaml";
      "scene ui" = "!include scenes.yaml";
      "script ui" = "!include scripts.yaml";
      default_config = { };
      http = {
        trusted_proxies = [ "127.0.0.1" ];
        use_x_forwarded_for = true;
      };
    };
  };

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant.enabled = true;
      permit_join = true;
      frontend = {
        enabled = true;
        host = "192.168.1.7";
        port = 8725;
      };
      serial = {
        adapter = "ember";
        port = "/dev/ttyUSB0";
      };

    };

  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        port = 1883;
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };

  services.udev = {
    enable = true;
    extraRules = ''
      KERNEL=="ttyUSB*", MODE="0666"
    '';
  };

}


