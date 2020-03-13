# https://rubydoc.brew.sh/Formula
class Anaconda2 < Formula
    version "2019.10"
    homepage "https://www.anaconda.com/"
    url "https://repo.anaconda.com/archive/Anaconda2-#{version}-Linux-x86_64.sh"
    sha256 "8b2e7dea2da7d8cc18e822e8ec1804052102f4eefb94c1b3d0e586e126e8cd2f"
    revision 0
    keg_only "conflicts with python2 and some libraries"

    def install
      system "chmod", "+x", "./Anaconda2-#{version}-Linux-x86_64.sh"
      system "./Anaconda2-#{version}-Linux-x86_64.sh", "-u", "-b", "-p", "#{prefix}"
    end
  end
