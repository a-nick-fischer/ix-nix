{
  pkgs,
  lib,
  ...
}: 
let
  # Watch that this thing is compatible with our ZFS version
  selectedKernelPackages = pkgs.linuxPackages_6_13;
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

    #lanzaboote = {
    #  enable = true;
    #  pkiBundle = "/etc/secureboot";
    #  configurationLimit = 10;
    #};

    # Lanzaboote currently replaces the systemd-boot module.
    loader = {
      systemd-boot.enable = true;

      efi.canTouchEfiVariables = true;
    };

    # Kernel
    # v4l2loopback needed for camera
    kernelModules = [ "kvm-intel" "v4l2loopback" ];
    
    extraModulePackages = [ selectedKernelPackages.v4l2loopback ];

    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1
    '';

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
