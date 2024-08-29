{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage {
  pname = "zen-surfer";
  version = "unstable-2024-08-26";

  src = fetchFromGitHub {
    owner = "zen-browser";
    repo = "surfer";
    rev = "22efae264dcba0afc36426c1b26f2be8f121848b";
    hash = "sha256-5hXOaEchXpaEu6wft/lGZPBHPYklyTQamDKUs81E3p8=";
  };

  # To fix `npm ERR! Your cache folder contains root-owned files`
  makeCacheWritable = true;

  npmDepsHash = "sha256-NGeaxU1LlrmOicL7NeeccXKvGg8pOc/W77e9lrhcx+c=";

  npmFlags = [ "--ignore-scripts" ];

  meta = with lib; {
    description = "Simplifying building firefox forks";
    homepage = "https://github.com/zen-browser/surfer";
    license = licenses.mpl20;
    maintainers = [ ];
    mainProgram = "surfer";
    platforms = platforms.all;
  };
}