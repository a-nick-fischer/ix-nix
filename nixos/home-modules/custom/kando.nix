{ appimageTools, fetchurl }:
let
  pname = "Kando";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/kando-menu/kando/releases/download/v${version}/${pname}-${version}-x86_64.AppImage";
    hash = "sha256-L0mBAilPjY3udk73I1njAzJlkoHxMDI3Q9mMJLK/fCk=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs:
    appimageTools.defaultFhsEnvArgs.multiPkgs pkgs;

  extraInstallCommands =
    let
      appimageContents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      # Install .desktop files
      install -Dm444 ${appimageContents}/kando.desktop -t $out/share/applications
      install -Dm444 ${appimageContents}/kando.png -t $out/share/pixmaps
    '';
}
