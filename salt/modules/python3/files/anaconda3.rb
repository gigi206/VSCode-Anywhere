# https://rubydoc.brew.sh/Formula
class Anaconda3 < Formula
    version "2020.02"
    homepage "https://www.anaconda.com/"
    url "https://repo.anaconda.com/archive/Anaconda3-#{version}-Linux-x86_64.sh"
    sha256 "2b9f088b2022edb474915d9f69a803d6449d5fdb4c303041f60ac4aefcc208bb"
    revision 0
    keg_only "conflicts with python3 and some libraries"

    def install
      system "chmod", "+x", "./Anaconda3-#{version}-Linux-x86_64.sh"
      system "./Anaconda3-#{version}-Linux-x86_64.sh", "-u", "-b", "-p", "#{prefix}"
    end
  end
