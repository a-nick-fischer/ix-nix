{
  ...
}: {
  fileSystems = {
    "/blobs" = {
        options = [
          "nosuid"
          "noexec"
          "nodev"
        ];
    };

    "/tmp" = {
        options = [
          "nosuid"
          "noexec"
          "nodev"
        ];
    };

    "/home" = {
      options = [
        "nosuid"
        "nodev"
      ];
    };

    # You do not want to install applications here anyways.
    "/root" = {
      options = [
        "nosuid"
        "noexec"
        "nodev"
      ];
    };

    "/var" = {
      options = [
        "nosuid"
        "nodev"
      ];
    };

    "/boot" = {
      options = [
        "nosuid"
        "noexec"
        "nodev"
      ];
    };

    "/srv" = {
      options = [
        "nosuid"
        "noexec"
        "nodev"
      ];
    };

    "/etc" = {
      device = "/etc";
      options = [
        "nosuid"
        "nodev"
      ];
    };

    "/downloads" = {
        options = [
          "nosuid"
          "noexec"
          "nodev"
        ];
    };
  };
}