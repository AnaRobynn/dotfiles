{ options, config, lib, pkgs, ... }:

with lib;
let hwCfg = config.modules.hardware;
    cfg = hwCfg.bluetooth;
in {
  options.modules.hardware.bluetooth = with types; {
    enable = mkOption {
      type = bool;
      default = false;
    };

    audio.enable = mkOption {
      type = bool;
      default = false;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hardware.bluetooth.enable = true;
      services.blueman.enable = true;
    }

    (mkIf cfg.audio.enable {
      hardware.pulseaudio = {
        # NixOS allows either a lightweight build (default) or full build of
        # PulseAudio to be installed.  Only the full build has Bluetooth
        # support, so it must be selected here.
        package = pkgs.pulseaudioFull;
        # Enable additional codecs
        extraModules = [ pkgs.pulseaudio-modules-bt ];
      };

      hardware.bluetooth.extraConfig = ''
        [General]
        Enable=Source,Sink,Media,Socket
      '';
    })
  ]);
}
