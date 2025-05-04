{ 
  pkgs,
  config,
  ... 
}:
{
  programs.firejail.enable = true;

  programs.wireshark.enable = true;

  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "light";
    image = config.lib.stylix.pixel "base0A";

    #https://rosepinetheme.com/themes/
    #https://github.com/tinted-theming/schemes/blob/spec-0.11/base16/rose-pine-moon.yaml
    #https://github.com/tinted-theming/schemes/blob/spec-0.11/base16/rose-pine-dawn.yaml
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-dawn.yaml";

    cursor.package = pkgs.rose-pine-cursor;
    cursor.name = "BreezeX-RosePine-Linux";
    cursor.size = 24;

    # Surpress invalid yaml files
    override.use-ifd = "always";

    fonts = {
      monospace = {
        package = pkgs._0xproto;
        name = "0xProto";
      };
    };
  };
}