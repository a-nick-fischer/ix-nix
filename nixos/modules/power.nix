{
  ...
}: {
  powerManagement.enable = true;
  services.thermald.enable = true;

  services.tlp.enable = false;

  # Needed for e.g. AGS
  services.upower.enable = true;

  services.auto-cpufreq = {
    enable = false; # TODO

    settings = {
      battery = {
        governor = "powersave";
        energy_performance_preference = "balance-power";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        energy_performance_preference = "performance";
        turbo = "always";
      };
    };
  };
}