{
  pkgs,
  lib,
  ...
}: 
let
  # Watch that this thing is compatible with our ZFS version
  selectedKernelPackages = pkgs.linuxPackages_6_16;
in {
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "de";
  };

  boot = {
    # Boot
    initrd = {
      systemd.enable = true;
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
      kernelModules = [  ];
    };

    plymouth.enable = true;

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 7;
      };

      efi.canTouchEfiVariables = true;
    };

    # Kernel
    kernelModules = [ "kvm-intel" ];

    kernelPackages = selectedKernelPackages;

    kernelParams = [
      "quiet"
      "splash"
      "nohibernate" # May be needed because of zfs bla bla

      # Simple interface names
      "net.ifnames=0"
      "biosdevname=0"

      "nvidia.NVreg_PreserveVideoMemoryAllocations=1" 
    ];
  };
}
