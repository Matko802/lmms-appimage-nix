{ appimageTools, fetchurl, lib }:
let
  pname = "lmms";
  version = "1.3.0-alpha.2";

  src = fetchurl {
    url = "https://github.com/LMMS/lmms/releases/download/v${version}/lmms-${version}-linux-x86_64.AppImage";
    hash = "sha256-dYDoMrmhAEHvYy6/LXDViPQcMb6MbIDR+altHAhxKYs=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # The default FHS env already ships ALSA / JACK / PulseAudio / PipeWire
  # client libs, so no extraPkgs are needed. If you use Windows VSTs through
  # the AppImage's Wine bridge, add `wineWowPackages.stable` to your system
  # packages separately (deliberately not a hard dep: huge closure).
  extraPkgs = pkgs: [ ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/lmms.desktop $out/share/applications/lmms.desktop
    cp -r ${appimageContents}/usr/share/icons $out/share/icons
  '';

  meta = with lib; {
    description = "LMMS music production suite (official AppImage: all instruments, effects and plugins bundled)";
    longDescription = ''
      LMMS packaged from the official upstream AppImage instead of nixpkgs,
      so every bundled plugin (ZynAddSubFX, VeSTige/VST support, SoundFont2,
      GIG player, Carla/LV2, all native instruments and effects) works
      out of the box.
    '';
    homepage = "https://lmms.io";
    downloadPage = "https://github.com/LMMS/lmms/releases/tag/v${version}";
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "lmms";
  };
}
