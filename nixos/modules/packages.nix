{ 
  pkgs,
  config,
  ... 
}:
{
  programs.firejail.enable = true;

  programs.wireshark.enable = true;
}
