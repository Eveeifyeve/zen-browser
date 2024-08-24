{ lib, stdenv, fetchFromGitHub, fetchurl, buildNpmPackage, callPackage, nixosTests }:
let
  firefoxVersion = "129.0.2";
  firefoxSrc = fetchurl {
    url = "mirror://mozilla/releases/firefox/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.xz";
    hash = lib.fakeSha256;
  };
in
buildNpmPackage rec {
  pname = "zen-browser";
  version = "0.0.1";

  # Src of zen-browser
  src = fetchFromGitHub {
    owner = "zen-browser";
    repo = "desktop";
    rev = version;
    hash = lib.fakeSha256;
    fetchSubmodules = true;
  };

  preBuild = ''
    # Patch Surfer to use Nix version of Firefox
    patch node_modules/@zen-browser/surfer/dist/utils/version.js < ${./default.nix}
    patch node_modules/@zen-browser/surfer/dist/commands/download/firefox.js < ${./default.nix}

    mkdir -p surfer/engine

    cp -r ${firefoxSrc} surfer/engine/firefox-${firefoxVersion}.source.tar.xz

    npm run init
  '';

  updateScript = callPackage ./update.nix { inherit pname; };
}
