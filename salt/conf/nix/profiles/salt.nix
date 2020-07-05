#with import (builtins.fetchGit {
#    # Descriptive name to make the store path easier to identify
#    url = https://github.com/nixos/nixpkgs-channels/;
#    # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-unstable`
#    ref = "refs/heads/nixos-19.09";
#    rev = "d1918bb0d90ee99601b18be55bba0fd78904e2a3";
#}) {};

let
  pkgs = import (builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    url = https://github.com/nixos/nixpkgs-channels/;
    # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-unstable`
    ref = "refs/heads/nixos-unstable";
    rev = "8d05772134f17180fb2711d0660702dae2a67313";
  }) {};

  pkgs_latest = import<nixpkgs> {};

  msgpack = pkgs.python37Packages.buildPythonPackage rec {
    pname = "msgpack";
    version = "0.6.2";
    name = "${pname}-${version}";
    # doCheck = false;

    src = pkgs.python37Packages.fetchPypi {
      inherit pname version;
      extension = "tar.gz";
      sha256 = "ea3c2f859346fcd55fc46e96885301d9c2f7a36d453f5d8f2967840efa1e1830";
    };

    meta = with pkgs.stdenv.lib; {
      homepage = https://github.com/msgpack/msgpack-python;
      description = "MessagePack serializer implementation for Python";
      license = licenses.asl20;
      authors = [ "Inada Naoki <songofacandy@gmail.com>" ];
      maintainers = [ "Ghislain LE MEUR" ];
    };
  };

  #py = pkgs.python37Packages.override {
  #  packageOverrides = self: super: {
  #    # Can be unpinned once https://github.com/saltstack/salt/issues/56007 is resolved
  #    msgpack = super.msgpack.overridePythonAttrs (
  #      oldAttrs: rec {
  #        version = "0.6.2";
  #        src = oldAttrs.src.override {
  #          inherit version;
  #          sha256 = "ea3c2f859346fcd55fc46e96885301d9c2f7a36d453f5d8f2967840efa1e1830";
  #        };
  #      }
  #    );
  #  };
  #};

  larkparser = pkgs.python37Packages.buildPythonPackage rec {
    pname = "lark-parser";
    version = "0.7.8";
    name = "${pname}-${version}";
    doCheck = false;

    src = pkgs.python37Packages.fetchPypi {
      inherit pname version;
      extension = "tar.gz";
      sha256 = "19103j8amnlzw5f23gi6dr2pwfwzbd2a96iifkpb4vvy2nxmw896";
    };

    meta = with pkgs.stdenv.lib; {
      homepage = https://github.com/lark-parser/lark;
      description = "Lark is a modern general-purpose parsing library for Python";
      license = licenses.mit;
      authors = [ "Erez SHINAN <erezshin@gmail.com>" ];
      maintainers = [ "Ghislain LE MEUR" ];
    };
  };

  commentjson = pkgs.python37Packages.buildPythonPackage rec {
    pname = "commentjson";
    version = "0.8.3";
    name = "${pname}-${version}";
    doCheck = false;

    src = pkgs.python37Packages.fetchPypi {
      inherit pname version;
      extension = "tar.gz";
      sha256 = "0lm6l9d1bh254ss2xvis3lfyy5lw5xqzzq1wj1bl27p4kx8h71vg";
    };

    propagatedBuildInputs = with pkgs; [
      larkparser
    ];

    meta = with pkgs.stdenv.lib; {
      homepage = https://github.com/vaidik/commentjson;
      description = "Helps you create JSON files with Python and JavaScript style inline comments";
      license = licenses.mit;
      authors = [ "Vaidik KAPOOR <kapoor.vaidik@gmail.com>" ];
      maintainers = [ "Ghislain LE MEUR" ];
    };
  };

  vscsaltsrc = pkgs.python37Packages.buildPythonApplication rec {
    pname = "vscsaltsrc";
    version = "3000.1.0";
    name = "${pname}-${version}";
    doCheck = false;

    src = ../../saltstack/src;

    # src = fetchFromGitHub {
    #   owner = "gigi206";
    #   repo = "salt";
    #   # rev = "vsc3000";
    #   rev = "742781c358d65c8849a6a6f5b8f4bb3dcefc203a";
    #   # nix-prefetch-url --unpack https://github.com/gigi206/vscode-anywhere/archive/b09b13992fa6c57647eea63274e67d45131e1e39.tar.gz
    #   sha256 = "02cgs6b1rmh8hmcwm5wpxxg32p3km9c05606pykv49qq1spd6p38";
    # };

    propagatedBuildInputs = with pkgs; [
      commentjson
      openssl
      # libgit2
      # python37Packages.pygit2
      # gitMinimal
      # setuptools and pip (pkg_resources) are required by the pip module/state
      python37Packages.setuptools
      python37Packages.pip
      python37Packages.distro
      python37Packages.GitPython
      python37Packages.jinja2
      python37Packages.markupsafe
      msgpack
      # python37Packages.msgpack
      python37Packages.pycryptodomex
      # python37Packages.pycrypto
      # python37Packages.m2crypto
      python37Packages.pyyaml
      python37Packages.pyzmq
      python37Packages.requests
      python37Packages.tornado_4
    ];
  };

  vscsalt = pkgs.stdenv.mkDerivation rec {
    pname = "vscsalt";
    version = "3000.1.0";
    name = "${pname}-${version}";

    # src = vscsaltsrc.src;
    # doCheck = false;

    #buildInputs = with pkgs_latest; [
    buildInputs = with pkgs; [
      # glibcLocales
      gitMinimal
      vscsaltsrc
    ];

    meta = with pkgs.stdenv.lib; {
      homepage = https://saltstack.com;
      description = "Portable, distributed, remote execution and configuration management system";
      maintainers = [ "Ghislain LE MEUR" ];
      # authors = [ "Ghislain LE MEUR" ];
      license = licenses.mit;
    };
  };
in vscsalt