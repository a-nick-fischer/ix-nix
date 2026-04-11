{pkgs, ...}: {
  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      wireplumber = {
        enable = true;
        # this prevents my bluetooth headphones from using mic which fucks the audio-quality
        configPackages = [
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
            wireplumber.settings = { bluetooth.autoswitch-to-headset-profile = false }
          '')
        ];
      };

      extraConfig.pipewire = {
        "98-crackling-fix" = {
          "context.properties" = {
            "default.clock.quantum" = 1024;
            "default.clock.min-quantum" = 1024;
            "default.clock.max-quantum" = 8192;
          };

          "api.alsa.period-size" = 1024;
          "api.alsa.headroom" = 8192;
        };
      };
    };

    # Touchpad
    libinput.enable = true;
  };
}
