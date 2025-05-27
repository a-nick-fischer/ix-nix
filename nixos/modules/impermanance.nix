{
  ...
}: {
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/secureboot"  # TODO: Remove if not using lanzaboote
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/db/sudo/lectured"
      "/etc/NetworkManager/system-connections"
    ];
  };
}
