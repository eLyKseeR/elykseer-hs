with import <nixpkgs> {};

stdenv.mkDerivation rec {
    name = "env";

    #src = ./.;

    # Customizable development requirements
    nativeBuildInputs = [
        cmake
        gcc
        git
        pandoc
        html2text
    ];

    buildInputs = [
        zlib
        boost
        gmp
        numactl
    ];

}

