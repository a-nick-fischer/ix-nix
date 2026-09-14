{ pkgs, ... }: {
  virtualisation = {
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

    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };
  };


  # Enable when needed
  #hardware.nvidia-container-toolkit.enable = true;
}
