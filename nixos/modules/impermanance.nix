{
  ...
}: {
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
}