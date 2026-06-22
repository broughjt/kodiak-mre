{
  description = "Minimal reproducible example for Kodiak";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    kodiak-src = {
      url = "github:nasa/Kodiak/cb77f1bb68e7ae8c7466bf8cbf4fe95ad619489a";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, flake-utils, kodiak-src, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        filib = pkgs.stdenv.mkDerivation {
          pname = "filib";
          version = "3.0.2";

          src = pkgs.fetchurl {
            url = "https://www2.math.uni-wuppertal.de/wrswt/software/filib++/filibsrc-3.0.2.tar.gz";
            sha256 = "14583ca412d0a081a176e115b452386fb7078bc590cf22af86db635fbf817562";
          };

          CFLAGS = "-fPIC";
          CPPFLAGS = "-fPIC";
          CXXFLAGS = "-fPIC -std=c++11";
        };

        kodiak = pkgs.stdenv.mkDerivation {
          pname = "kodiak";
          version = "2.0.4";

          src = kodiak-src;

          nativeBuildInputs = [ pkgs.cmake ];
          buildInputs = [ filib ];

          FILIB_ROOT = filib;

          # Kodiak's install target installs the library but not public headers.
          postInstall = ''
            cd $src/src
            find . -type f \( -name '*.hpp' -o -name '*.h' \) \
              -exec install -Dm644 {} "$out/include/kodiak/{}" \;
          '';
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [ kodiak filib ];

          packages = with pkgs; [
            clang-tools
            cmake
            gdb
            gnumake
          ];

          KODIAK_ROOT = kodiak;
          FILIB_ROOT = filib;
        };
      }
    );
}
