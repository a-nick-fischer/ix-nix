{
  pkgs,
  lib,
  config,
  ...
}: {
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

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    # Lanzaboote currently replaces the systemd-boot module.
    loader = {
      systemd-boot = {
        enable = lib.mkForce false;
        configurationLimit = 7;
      };

      efi.canTouchEfiVariables = true;
    };

    # ZFS
    supportedFilesystems = [ "zfs" ];
    zfs.requestEncryptionCredentials = true;

    # Kernel
    # v4l2loopback needed for camera
    kernelModules = [ "kvm-intel" "v4l2loopback" ];
    
    extraModulePackages = [ config.boot.zfs.package.latestCompatibleLinuxPackages.v4l2loopback ];

    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1
    '';

    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

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