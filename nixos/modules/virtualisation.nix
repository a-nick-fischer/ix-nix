{...}: {
  virtualisation = {
    libvirtd.enable = true;

    containers = {
      enable = true;
      registries.search = [ "docker.io" ];
    };

    podman = {
      enable = true;

      dockerCompat = true;
      dockerSocket.enable = true;

      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Enable when needed
  #hardware.nvidia-container-toolkit.enable = true;
}
