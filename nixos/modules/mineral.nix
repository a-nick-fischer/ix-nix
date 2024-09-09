{ 
  lib,
  inputs,
  ... 
}: lib.mkMerge([
    # Needed because per-default this conflicts with Disko
    (removeAttrs (import "${inputs.nix-mineral}/nix-mineral.nix") [ "fileSystems" ])

    {
      # Overrides, see https://github.com/cynicsketch/nix-mineral/blob/main/nm-overrides.nix

      # Enable compatibility overrides
      nm-overrides.compatibility.allow-unsigned-modules.enable = true;
      nm-overrides.compatibility.no-lockdown.enable = true;
      nm-overrides.compatibility.binfmt-misc.enable = true;
      nm-overrides.compatibility.busmaster-bit.enable = true;
      nm-overrides.compatibility.io-uring.enable = true;
      nm-overrides.compatibility.ip-forward.enable = true;

      # Enable this for 32bit emulation
      # nm-overrides.desktop.allow-multilib.enable = true;

      # Needed for podman, bubblewrap, chromium-sandbox
      nm-overrides.desktop.allow-unprivileged-userns.enable = true;

      # Allow executing apps in /home
      # nm-overrides.desktop.home-exec.enable = true;

      # Allow executing binaries in /tmp. Certain applications may need to execute
      # in /tmp, Java being one example.
      # nm-overrides.desktop.tmp-exec.enable = true;

      # Fuck this i'm not messing with USBGuard
      nm-overrides.desktop.usbguard-disable.enable = true;

      # May be required for games and some apps
      # nm-overrides.desktop.yama-relaxed.enable = true;
      # nm-overrides.desktop.hideproc-relaxed.enable = true;

      # Right... we're not THAT paranoid...
      # I do not expect to be targeted by Meltdown
      nm-overrides.performance.no-mitigations.enable = true;
      nm-overrides.performance.no-pti.enable = true;

      # Do not leak system time
      nm-overrides.security.tcp-timestamp-disable.enable = true;

      # Disable Intel ME Kernel modules... ye I'm too scared for that right now
      # nm-overrides.security.disable-intelme-kmodules.enable = true;

      # Replace systemd-timesyncd with chrony, for NTS support and its seccomp
      # filter.
      nm-overrides.software-choice.secure-chrony.enable = true;
    }
])
