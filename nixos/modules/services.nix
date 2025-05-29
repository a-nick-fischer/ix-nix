{
  pkgs,
  ...
}: {
  security.polkit.enable = true;
  services.dbus.implementation = "broker";

  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  # Needed for Gnome
  services.xserver = {
    # Required for DE to launch.
    enable = true;

    desktopManager.gnome.enable = true;
    
    xkb.layout = "de";

    # Exclude default X11 packages I don't want.
    excludePackages = with pkgs; [ xterm ];
  };

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      settings = {
        Autologin = {
          User = "nick";
        };
      };
    };

    defaultSession = "gnome";
  };

  # Better OOM-Daemon 'cause fuck systemd-oom
  systemd.oomd.enable = false;
  services.earlyoom = {
    enable = true;
    enableNotifications = true;

    # Send SIGTERM when only 2% of RAM and (!!!) SWAP are free
    # Sends SIGKILL on 1%
    freeMemThreshold = 2;
    freeSwapThreshold = 2;
    
    extraArgs = [
      "-g"
      "--prefer" "(^|/)(java|chromium|librewolf|electron)$"
     "--ignore" "(^|/)(systemd)$" # TODO Add gnome stuff here
    ];
  };

  # Proxy systemd-bus notifications to libnotify
  services.systembus-notify.enable = true;

  # Nobody needs the default 4GB of logs...
  services.journald.extraConfig = ''
    SystemMaxUse=500M
  '';

  # https://discourse.nixos.org/t/zfs-rollback-not-working-using-boot-initrd-systemd/37195/2
  #boot.initrd.systemd.services.rollback = {
  #  description = "roolback rootfs on boot";
  #  wantedBy = [
  #    "initrd.target"
  #  ];
  #  after = [
  #    # This service is called zfs-import-<poolname>.service
  #    # Look up your poolname in disko.nix next time before debugging for 3 hours...
  #    "zfs-import-zroot.service"
  #  ];
  #  before = [
  #    "sysroot.mount"
  #  ];
  #  path = with pkgs; [
  #    zfs
  #  ];
  #  unitConfig.DefaultDependencies = "no";
  #  serviceConfig.Type = "oneshot";
  #  script = ''
  #    zfs rollback -r zroot/root@blank
  #  '';
  #};
}
