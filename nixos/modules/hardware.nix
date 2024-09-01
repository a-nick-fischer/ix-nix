{
  modulesPath,
  ...
}: {
  imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # TODO https://github.com/sioodmy/dotfiles/blob/1e8a972bfbefeeb4150f5707001ce243dce1f6ea/system/core/schizo.nix
  # TODO https://pastebin.com/VwrgZsJJ

  zramSwap = {
    enable = true;
    memoryPercent = 30;
    writebackDevice = "/dev/nvme0n1p3";
  };

  hardware.cpu.intel.updateMicrocode = true;
}