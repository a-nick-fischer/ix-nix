{
  pkgs,
  ...
}: {
  #security.polkit.enable = true;
  #services.dbus.implementation = "broker";

  # Needed for Gnome
  #services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  # Needed for Gnome
  services.xserver = {
    # Required for DE to launch.
    enable = true;
    displayManager.gdm = {
        enable = true;
        wayland = true;
    };

    desktopManager.gnome.enable = true;
    
    # Configure keymap in X11.
    # layout = user.services.xserver.layout;
    # xkbVariant = user.services.xserver.xkbVariant;

    # Exclude default X11 packages I don't want.
    # excludePackages = with pkgs; [ xterm ];
  };

  # TODO Move to programs
  programs.dconf.enable = true;
  # TODO Disable core apps?
  # services.gnome.core-apps.enable = false;

  # Better OOM-Daemon 'cause fuck systemd-oom
  #systemd.oomd.enable = false;
  #services.earlyoom = {
  #  enable = true;
  #  enableNotifications = true;

    # Send SIGTERM when only 2% of RAM and (!!!) SWAP are free
    # Sends SIGKILL on 1%
  #  freeMemThreshold = 2;
  #  freeSwapThreshold = 2;
    
  #  extraArgs = [
  #    "-g"
  #    "--prefer" "(^|/)(java|chromium|librewolf|electron)$"
  #   "--ignore" "(^|/)(systemd)$" # TODO Add gnome stuff here
  #  ];
  #};

  # Proxy systemd-bus notifications to libnotify
  #services.systembus-notify.enable = true;

  # Auto-mounting
  #services.udisks2 = {
  #  enable = true;
  #  mountOnMedia = true;
 # };

  #services.devmon.enable = true;
  #services.gvfs.enable = true; 

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
