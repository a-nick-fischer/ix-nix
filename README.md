# Installation

1. Make sure to download the graphical NixOS-installer and boot into the LTS kernel - this is needed for ZFS support

2. Close the installer, change keyboard layout, connect to the wireless via the UI. If the UI is unavailable for some reason, do:
```bash
sudo systemctl start wpa_supplicant
sudo wpa_cli
scan
scan_results
add_network 0
set_network 0 ssid "..."
set_network 0 psk "..."
enable_network 0
```

3. Clone this repo
```bash
git clone https://github.com/a-nick-fischer/ix-nix.git

# Optionally remove the flake.lock if you want to update all inputs
rm "ix-nix/nixos/flake.lock" 
```

4. Format disk **(WARNING: THIS WILL FORMAT THE DISK /dev/nvme0n1, CHANGE AS NEEDED)**
```bash
sudo nix run --experimental-features "nix-command flakes" github:nix-community/disko/latest -- --mode destroy,format,mount "ix-nix/nixos/modules/disko.nix"
# You should be asked for a ZFS password... if not, double check that the command was successful.
# Also, check if /mnt is non-empty
```

5. Copy stuff to our new disk
```bash
sudo mkdir -p /mnt/home/nick/.config/
sudo cp -r ix-nix/* /mnt/home/nick/.config/
```

6. Run the installer (installation directory defaults to `/mnt`)
```bash
sudo nixos-install --flake "${HOME}/ix-nix/nixos#ix"
```
