# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, outputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    backupFileExtension = "backup";
    users = {
      nick = import ./home.nix;
    };
  };

  programs.hyprland = {
     enable = true;
     package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  nix.gc = {
    automatic = true;
    dates = "monthly";
    options = "--delete-older-than 30d"; 
  };

  boot = {
    initrd.systemd.enable = true;

    plymouth.enable = true;

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 7;
      };

      efi.canTouchEfiVariables = true;
    };

    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.dbus.implementation = "broker";

  # Create download dir as temp dir
  # TODO Switch to partition
  systemd.tmpfiles.rules = [
    "d /downloads 0755 nick"
  ];

  systemd = {
    # Started manually by hyprland
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
  };

  # TODO https://github.com/Geometer1729/persist-retro
  # TODO switch to impermanence.nukeRoot.enable?
  # TODO Reverse-engineer https://github.com/vimjoyer/nixconf/tree/main

  users.users."nick" = {
    isNormalUser = true;
    shell = pkgs.nushell;
    initialPassword = "nixos"; # TODO find a better way
    extraGroups = [ "wheel" ];
  };

  environment.sessionVariables = {
    FLAKE = "/home/nick/.config/nixos";
    DEFAULT_BROWSER = "${pkgs.librewolf}/bin/librewolf";
    BROWSER = "${pkgs.librewolf}/bin/librewolf";
  };

  networking.hostName = "ix"; # Define your hostname.
  networking.hostId = "fff69420";

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = true;

  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "light";
    image = config.lib.stylix.pixel "base0A";

    # TODO rose-pine-icon-theme

    #https://rosepinetheme.com/themes/
    #https://github.com/tinted-theming/schemes/blob/spec-0.11/base16/rose-pine-moon.yaml
    #https://github.com/tinted-theming/schemes/blob/spec-0.11/base16/rose-pine-dawn.yaml
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-dawn.yaml";

    cursor.package = pkgs.rose-pine-cursor;
    cursor.name = "BreezeX-RosePine-Linux";

    fonts = {
      monospace = {
        package = pkgs._0xproto;
        name = "0xProto";
      };
    };
  };

  # Power Management
  powerManagement.enable = true;
  services.thermald.enable = true;

  services.tlp.enable = false;

  services.auto-cpufreq = {
    enable = false;

    settings = {
      battery = {
        governor = "powersave";
        energy_performance_preference = "balance-power";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        energy_performance_preference = "performance";
        turbo = "always";
      };
    };
  };

  services.fstrim.enable = true;


  # https://discourse.nixos.org/t/zfs-rollback-not-working-using-boot-initrd-systemd/37195/2
   boot.initrd.systemd.services.rollback = {
        description = "roolback rootfs on boot";
        wantedBy = [
          "initrd.target"
        ];
        after = [
          # This service is called zfs-import-<poolname>.service
          # Look up your poolname in disko.nix next time before debugging for 3 hours...
          "zfs-import-zroot.service"
        ];
        before = [
          "sysroot.mount"
        ];
        path = with pkgs; [
          zfs
        ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          zfs rollback -r zroot/root@blank
        '';
      };

  services.zfs.autoScrub.enable = true;

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/Vienna";

  zramSwap = {
    enable = true;
    memoryPercent = 30;
    writebackDevice = "/dev/nvme0n1p3";
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "de";
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      open = false;
      
      powerManagement = {
        enable = true;
        finegrained = false;
      };

      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
  
        # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA 
        nvidiaBusId = "PCI:1:0:0"; 
    
        # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA 
        intelBusId = "PCI:0:2:0";
      };
    };
  };

  hardware.cpu.intel.updateMicrocode = true;

  boot.kernelParams = [
    "quiet"
    "splash"
    "nohibernate" # May be needed because of zfs bla bla

    # Simple interface names
    "net.ifnames=0"
    "biosdevname=0"

    "nvidia.NVreg_PreserveVideoMemoryAllocations=1" 
  ];

  security.polkit.enable = true;

  environment.etc."machine-id".source = "/persist/etc/machine-id";
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
       "/var/lib/bluetooth"
       "/var/lib/nixos"
       "/var/lib/systemd/coredump"
       "/var/db/sudo/lectured"
       "/etc/NetworkManager/system-connections"
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # TODO: Network manager applet nm-applet?

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
     enable = true;
     pulse.enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Needed for e.g. AGS
  services.upower.enable = true;

  system.activationScripts.setPermissions = ''
    chown -R nick: {/projects,/blobs,/etc/nixos}
    chmod -R 700 {/projects,/blobs,/etc/nixos}
  '';

  nixpkgs.config.allowUnfree = true;
  

  # Auto-login
  services.getty.autologinUser = "nick";

  # List services that you want to enable:

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}
