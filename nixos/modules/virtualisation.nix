{
  pkgs,
  ...
}: {
  virtualisation = {
    libvirtd.enable = true;

    containers.enable = true;

    # TODO: we cannot use the filesystem with ZFS, mount with
    # acltype=posixacl
    # See https://nixos.wiki/wiki/Podman
    podman = {
      enable = true;

      dockerCompat = true;

      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Enable when needed
  #hardware.nvidia-container-toolkit.enable = true;

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose # start group of containers for dev
  ];
}