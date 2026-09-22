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
appimageTools.wrapAppImage {
  inherit pname version;
  src = appimageContents;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/lmms.desktop $out/share/applications/lmms.desktop
    chmod u+w $out/share/applications/lmms.desktop
    echo "StartupWMClass=AppRun.wrapped" >> $out/share/applications/lmms.desktop
    chmod 444 $out/share/applications/lmms.desktop
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
