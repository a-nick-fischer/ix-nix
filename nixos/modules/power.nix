{
  ...
}: {
  powerManagement.enable = true;
  services.thermald.enable = true;

  #services.tlp.enable = false;

  # Needed for e.g. AGS
  # TODO Needed?
  #services.upower.enable = true;

  # TODO Uhm, does this work at all?
  #services.auto-cpufreq = {
  #  enable = false; # TODO This conflicts with gnome.. what is better?

  #  settings = {
  #    battery = {
  #      governor = "powersave";
  #      energy_performance_preference = "balance-performance";
  #      turbo = "never";
  #    };
  #    charger = {
  #      governor = "performance";
  #      energy_performance_preference = "performance";
  #      turbo = "auto";
  #    };
  #  };
  #};
}