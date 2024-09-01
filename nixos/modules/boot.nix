{
  config,
  ...
}: {
  boot = {
    # Boot
    initrd = {
      systemd.enable = true;
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
      kernelModules = [ ];
    };

    plymouth.enable = true;

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 7;
      };

      efi.canTouchEfiVariables = true;
    };

    # ZFS
    supportedFilesystems = [ "zfs" ];
    zfs.requestEncryptionCredentials = true;

    # Kernel
    # TODO https://discourse.nixos.org/t/how-to-get-compatible-hardened-kernel-for-zfs-module/32491/3
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
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