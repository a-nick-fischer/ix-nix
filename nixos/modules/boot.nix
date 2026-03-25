{
  pkgs,
  ...
}: let
  # Watch that this thing is compatible with our ZFS version
  selectedKernelPackages = pkgs.linuxPackages_6_18;
in {
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "de";
  };

  boot = {
    # Boot
    initrd = {
      systemd.enable = true;
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "sdhci_pci"];
    };

    plymouth = {
      enable = true;
      themePackages = with pkgs; [ adi1090x-plymouth-themes ];
      theme = "circle_hud";
    };

    loader = {
      limine = {
        # 1. Step - disable systemdboot and enable this
        enable = true;
        # 2. Step - persist sbctl folder, enroll keys, enable this
        secureBoot.enable = true;
        # 3. Step - everything fine? - disable this
        enableEditor = true;
        maxGenerations = 7;
      };

      systemd-boot = {
        enable = false;
        configurationLimit = 7;
      };

      efi.canTouchEfiVariables = true;
    };

    # Kernel
    kernelModules = ["kvm-intel"];

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

    tmp.cleanOnBoot = true;
  };
}
