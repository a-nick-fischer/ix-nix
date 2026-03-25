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
      # Load display-related DRM drivers early so Plymouth can render on HDMI outputs.
      kernelModules = ["i915" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
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

        style = {
          interface.branding = "";
          wallpapers = [ ];
          graphicalTerminal = {
            palette = "1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
            background = "1e1e2e";
            foreground = "cdd6f4";
            brightPalette = "585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
            brightBackground = "585b70";
            brightForeground = "cdd6f4";
            font.scale = "2x2";
          };
        };

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

      # Required for early NVIDIA DRM KMS during initrd/Plymouth.
      "nvidia-drm.modeset=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];

    tmp.cleanOnBoot = true;
  };
}
