{
  ...
}: {
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      # Re-add once we have lanzaboote again "/etc/secureboot"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/db/sudo/lectured"
      "/etc/NetworkManager/system-connections"
      "/var/lib/sddm/state.conf
    ];
  };
}