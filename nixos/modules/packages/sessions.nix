{
  lib,
  buildGoModule,
  fetchFromGitHub,
  blueprint-compiler,
  makeWrapper,
  pkg-config,
  installShellFiles,
  desktop-file-utils,
  cairo,
  gettext,
  glib,
  gtk4,
  libadwaita,
  gsettings-desktop-schemas,
  hicolor-icon-theme,
}: buildGoModule rec {
  pname = "sessions";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "pojntfx";
    repo = "sessions";
    rev = "v${version}";
    hash = "sha256-pcIE93Jt7moWgSlulCk5lrkwSj10w75agsyffZI9zDo=";
  };

  proxyVendor = true;
  vendorHash = "sha256-HuJEOZ8wa6c51K5MENc2CitXrf6vcfwxKGtHKB9H1+o=";
  runGoGenerate = false;

  nativeBuildInputs = [
    blueprint-compiler
    makeWrapper
    gettext
    installShellFiles
    desktop-file-utils
    glib
  ];

  buildInputs = [
    cairo
    gtk4
    libadwaita
    gsettings-desktop-schemas
    hicolor-icon-theme
  ];

  preBuild = ''
    go generate ./assets/resources
  '';

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.LocaleDir=$out/share/locale"
  ];

  postInstall = ''
    install -Dm644 assets/meta/com.pojtinger.felicitas.Sessions.desktop \
      $out/share/applications/com.pojtinger.felicitas.Sessions.desktop
    install -Dm644 assets/resources/metainfo.xml \
      $out/share/metainfo/com.pojtinger.felicitas.Sessions.metainfo.xml
    install -Dm644 assets/meta/icon.svg \
      $out/share/icons/hicolor/scalable/apps/com.pojtinger.felicitas.Sessions.svg
    install -Dm644 assets/meta/icon-symbolic.svg \
      $out/share/icons/hicolor/symbolic/apps/com.pojtinger.felicitas.Sessions-symbolic.svg

    mkdir -p $out/share/locale
    (cd po && find . -name '*.mo' -exec cp --parents {} $out/share/locale/ \;)

    install -Dm644 assets/resources/index.gschema.xml \
      $out/share/glib-2.0/schemas/com.pojtinger.felicitas.Sessions.gschema.xml
    glib-compile-schemas $out/share/glib-2.0/schemas

    substituteInPlace $out/share/applications/com.pojtinger.felicitas.Sessions.desktop \
      --replace-fail "Exec=sessions" "Exec=$out/bin/sessions"
    desktop-file-validate $out/share/applications/com.pojtinger.felicitas.Sessions.desktop

    wrapProgram $out/bin/sessions \
      --set PUREGOTK_LIB_FOLDER "${lib.makeLibraryPath [
        cairo
        glib
        gtk4
        libadwaita
      ]}" \
      --prefix PATH : "${lib.makeBinPath [pkg-config]}"
  '';

  meta = {
    description = "Simple visual Pomodoro timer";
    homepage = "https://github.com/pojntfx/sessions";
    license = lib.licenses.agpl3Only;
    mainProgram = "sessions";
    platforms = lib.platforms.linux;
    maintainers = [];
  };
}