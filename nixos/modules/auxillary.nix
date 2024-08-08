{
  ...
}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # TODO: Network manager applet nm-applet?

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
    };

    # Touchpad
    libinput.enable = true;
  }; 
}