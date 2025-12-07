{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 30;
  };

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  hardware.bluetooth.powerOnBoot = true;
  hardware.logitech.wireless.enable = true;
  hardware.uinput.enable = true;
}
