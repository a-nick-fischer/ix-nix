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
          "bind"
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
        "bind"
        "nosuid"
        "noexec"
        "nodev"
      ];
    };

    "/var" = {
      options = [
        "bind"
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
        "bind"
        "nosuid"
        "noexec"
        "nodev"
      ];
    };

    "/etc" = {
      options = [
        "bind"
        "nosuid"
        "nodev"
      ];
    };

  # TODO Uncomment later
    #"/downloads" = {
    #    options = [
    #      "nosuid"
    #      "noexec"
    #      "nodev"
    #    ];
    # };
  };
}