let
  config = {
    allowUnfree = true;
  };
  hostPkgs = import <nixpkgs> {};
  pinnedVersion = hostPkgs.lib.importJSON ./nix/nixpkgs-version.json;
  pinnedPkgs = hostPkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    inherit (pinnedVersion) rev sha256;
  };
  pinnedPython = hostPkgs.python36.withPackages
        (pypkgs: with pypkgs; [
        pytest
        requests
        ]);

in with import pinnedPkgs { inherit config; };
stdenv.mkDerivation rec {
  name = "env";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [
  pinnedPython
  ];
}
