{
  ...
}: {
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
}