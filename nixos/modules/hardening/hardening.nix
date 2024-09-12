{
  lib,
 ... 
}: 
{
  imports = [
    ./filesystem.nix
    ./network.nix
  ];

    # We're borrowing things from nix-mineral, the whole config is a bit overkill
  # See https://github.com/cynicsketch/nix-mineral/blob/main/nix-mineral.nix
  boot = {
    kernel.sysctl = {
      # enable ASLR
      # turn on protection and randomize stack, vdso page and mmap + randomize brk base address
      "kernel.randomize_va_space" = "2";
    };

    # Disable the editor in systemd-boot, the default bootloader for NixOS.
    # This prevents access to the root shell or otherwise weakening
    # security by tampering with boot parameters. If you use a different
    # boatloader, this does not provide anything. You may also want to
    # consider disabling similar functions in your choice of bootloader.
    loader.systemd-boot.editor = false;
  };  

  environment.etc = {
    # Empty /etc/securetty to prevent root login on tty.
    securetty.text = ''
      # /etc/securetty: list of terminals on which root is allowed to login.
      # See securetty(5) and login(1).
    '';

    # Set machine-id to the Kicksecure machine-id, for privacy reasons.
    # /var/lib/dbus/machine-id doesn't exist on dbus enabled NixOS systems,
    # so we don't have to worry about that.
    machine-id.text = ''
      b08dfa6083e7567a1921a715000001fb
    '';
  };

  # Limit access to nix to users with the "wheel" group. ("sudoers")
  nix.settings.allowed-users = lib.mkForce [ "@wheel" ];
}