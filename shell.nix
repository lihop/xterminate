let
  pkgs = import <nixpkgs> {};

  libPath = with pkgs; lib.makeLibraryPath [ libcxx ];

  pythonEnv = pkgs.python39.withPackages(python39Packages:
    let
      cxxfilt = python39Packages.buildPythonPackage rec {
        pname = "cxxfilt";
        version = "0.2.2";

        buildInputs = with pkgs; [ gcc ];
        doCheck = true;

        src = python39Packages.fetchPypi {
          inherit pname version;
          sha256 = "0az9d4ncr38fb43wv6rzq072f7gxxvcf4wb3p48mrj8ndpki0s7g";
        };

        LD_LIBRARY_PATH = libPath;
      };
    in
    with python39Packages; [
      cxxfilt
      pip
      pybindgen
      pygccxml
      setuptools
      virtualenv
      wheel
    ]
  );
in pkgs.mkShell {
  CXXFLAGS = "-Wall";
  LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${libPath}";
  PYTHON_PATH = "${pkgs.python39}/bin/python";

  buildInputs =  with pkgs; [
    binutils.bintools
    cacert
    castxml
    cmake
    dotnetCorePackages.sdk_3_1
    git
    ncurses
    pkg-config
    python39
    python39Packages.setuptools
    pythonEnv
    scons
    wafHook
    which
  ];
}
