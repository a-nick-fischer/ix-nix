{
  ...
}: {
  imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 30;
    writebackDevice = "/dev/nvme0n1p3";
  };

  hardware.cpu.intel.updateMicrocode = true;
}