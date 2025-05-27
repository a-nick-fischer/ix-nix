{
  device ? throw "Set this to your disk device, e.g. /dev/nvme0n1",
  ...
}:
{
  disko.devices = {
    disk.main = {
      device = device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1G";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          swap = {
            size = "8G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
          zfs = {
            name = "root";
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          acltype = "posixacl";
          dnodesize = "auto";
          xattr = "sa";
          relatime = "on";
          normalization = "formD";
          mountpoint = "none";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        options = {
          ashift = "12";
          autotrim = "on";
          "metaslab_lba_weighting_enabled" = "0";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            postCreateHook = "zfs snapshot zroot/root@blank";
          };
          nix = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            options.atime = "off";
            mountpoint = "/nix";
          };
          persist = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "true";
            mountpoint = "/persist";
          };
          log = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/var/log";
          };
          projects = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "true";
            mountpoint = "/projects";
          };
          blobs = {
            type = "zfs_fs";
            options.recordsize = "1M";
            options.mountpoint = "legacy";
            mountpoint = "/blobs";
          };
          home = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "true";
            mountpoint = "/home";
          };
        };
      };
    };
  };
  fileSystems = {
    "/".neededForBoot = true;
    "/nix".neededForBoot = true;
    "/persist".neededForBoot = true;
    "/projects".neededForBoot = true;
    "/blobs".neededForBoot = true;
    "/home".neededForBoot = true;
    "/boot".neededForBoot = true;
  };
}



