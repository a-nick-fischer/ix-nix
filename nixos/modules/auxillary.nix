{
  ...
}: {
  hardware.bluetooth = {
    enable = false; # Disable to test new dongle
    powerOnBoot = false;
  };

  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;
      jack.enable = true;
    };

    # Touchpad
    libinput.enable = true;
  }; 
}