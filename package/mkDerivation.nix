{lib, stdenv, pnpm_9}:
let 
  firefox-version = "109.0.1";
  firefox-src = fetchurl {
    url = "mirror://mozilla/releases/firefox-${firefox-version}/source/firefox-${firefox-version}.source.tar.xz";
    hash = lib.fakeSha256;
  };
in 
stdenv.mkDerivation rec { 
  pname = "";
}