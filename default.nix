{lib, stdenv, pnpm, nodejs, fetchurl, fetchFromGitHub}:
let 
  firefox-version = "129.0.2";
  firefox-src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${firefox-version}/source/firefox-${firefox-version}.source.tar.xz";
    hash = "sha512-9oBah+XLTkN1g5FuPsGzEtxz7sX8Bs56A4sTvXxoJ7GM84PDBkXZZiPOQWdTUfMCPsa5+J1nbxyImZTq558sEw==";
  };
in 
stdenv.mkDerivation rec { 
  pname = "zen-browser";
  version = "1.0.0-a.32";

  nativeBuildInputs = [
    pnpm.configHook
    nodejs
  ];

  src = fetchFromGitHub {
    owner = "zen-browser";
    repo = "desktop";
    rev = version;
    hash = "sha256-ryN+Ca0IIybnGWnlSCkstnYBfahvsU/XwR8V0VSB6KA=";
    fetchSubmodules = true;
  };

  pnpmDeps = pnpm.fetchDeps {
    pname = "${pname}-pnpm-deps";
    inherit src version;
    hash = "sha256-gVKWHxzCY89n2CJRCA2f5vlgmHSYgRsCK8sWKCLf5Hk=";
  };


  # Provides Firefox source required to build
  preBuild = ''
    mkdir -p .surfer/engine
    cp -r ${firefox-src} .surfer/engine/firefox-${firefox-version}.source.tar.xz
    pnpm run bootstrap && pnpm run import
  '';

  buildPhase = ''
    #TODO: Lanaguage Pack support
    # Build language Packs

    # Build Zen Browser TODO: Issue #2
    exit 1
    pnpm build
  '';

  installPhase = ''
    #TODO: Find out where zen builds to.
  '';

  meta = with lib; {
    description = "A browser for the future";
    homepage = "";
    license = licenses.mpl20;
    platforms = platforms.all;
  };

  
}