{
  modulesPath,
  ...
}: {
  imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 30;
  };

  hardware.cpu.intel.updateMicrocode = true;
}