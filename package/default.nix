{
  stdenv, lib, callPackage, buildMozillaMach, nixosTests,
}:
let
  srcJson = lib.importJSON ./src.json;
  src = {
    source = fetchFromGitHub {
      owner = "ZenBrowser";
      repo = "ZenBrowser";
      fetchSubmodules = true;
      inherit (srcJson.zenbrowser) rev sha256;
    };
    firefox = fetchUrl {
      url = "mirror://mozilla/firefox/releases/${srcJson.firefox.version}/source/firefox-${srcJson.firefox.version}.source.tar.xz";
      inherit (srcJson.firefox) rev sha256;
    };
  };
in 
(buildMozillaMach rec {
  pname = "zen-browser";

  meta = with lib; {
    description = "A browser based on Firefox and Chromium";
    homepage = "https://github.com/ZenBrowser/ZenBrowser";
    maintainers = with maintainers; [ ]; # TODO: add maintainers
    license = licenses.mpl20;
    platforms = platforms.all;
    broken = platforms.linux; # Testing needs to be done on Linux
  };
})