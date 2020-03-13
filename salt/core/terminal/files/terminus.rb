# https://rubydoc.brew.sh/Formula
class Terminus < Formula
    version "1.0.112"
    homepage "https://eugeny.github.io/terminus/"
    url "https://github.com/Eugeny/terminus/releases/download/v#{version}/terminus-#{version}-linux.tar.gz"
    sha256 "e8a818e80c51d2ac4289b0983de9af962eb4a59467a3548af00ac1eb24804635"
    revision 0

    def install
      system "cp", "-a", ".", "#{prefix}"
    end
  end
