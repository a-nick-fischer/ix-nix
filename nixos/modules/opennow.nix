{ appimageTools, fetchurl, lib }:
appimageTools.wrapType2 {
  pname = "opennow";
  version = "0.2.4";
  src = fetchurl {
    url = "https://github.com/OpenCloudGaming/OpenNOW/releases/download/nightly-60030b626b57914e9e4d538aba1d4ed954a82653/OpenNOW-v0.2.4-linux-x86_64.AppImage";
    sha256 = "sha256-2rNxprNnW7BjiPDeVSq6zjTh3iIKAoxG9PyYBt9SlSQ=";
  };
  meta = with lib; {
    description = "OpenNOW cloud gaming client";
    homepage = "https://github.com/OpenCloudGaming/OpenNOW";
    license = licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
  };
}
