{lib, stdenv, pnpm, nodejs, fetchurl, fetchFromGitHub}:
let 
  firefoxVersions = lib.importJSON ./firefoxVersion.json;
  firefox-version = firefoxVersions.stable;
  firefox-src = fetchurl {
    url = "mirror://mozilla/releases/firefox-${firefox-version}/source/firefox-${firefox-version}.source.tar.xz";
    hash = lib.fakeSha256;
  };
in 
stdenv.mkDerivation rec { 
  pname = "zen-browser";
  version = "0.0.1";

  nativeBuildInputs = [
    pnpm
    nodejs
  ];

  src = fetchFromGitHub {
    owner = "zen-browser";
    repo = "zen-browser";
    rev = "v${version}";
    hash = lib.fakeSha256;
    fetchSubmodules = true;
  };

  pnpmDeps = pnpm.fetchDeps {
    pname = "${pname}-pnpm-deps";
    inherit src version;
    hash = lib.fakeSha256;
  };


  # Provides Firefox source required to build
  preBuild = ''
    mkdir -p .surfer/engine
    cp -r ${firefox-src} .surfer/engine/firefox-${firefox-version}.source.tar.xz
    pnpm run bootstrap && pnpm run import
  '';

  
}