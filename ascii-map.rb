class AsciiMap < Formula
  include Language::Python::Virtualenv

  desc "Terminal-based ASCII map explorer"
  homepage "https://github.com/Luthiraa/ascii-map"
  url "https://github.com/Luthiraa/ascii-map/archive/v0.1.2.tar.gz"
  sha256 "91a78815e0148500594e1cde40767747665f1fbdc11ce572af46c88584c63057"
  license "MIT"

  depends_on "python@3.11"

  def install
    # Create virtualenv
    venv = virtualenv_create(libexec, "python3.11")

    # Install all dependencies directly from PyPI using binary wheels.
    # We bypass Homebrew's resource system because it forces --no-binary=:all:
    # which tries to compile C extensions (shapely, pyclipper) from source,
    # requiring numpy, Cython, cmake, meson, GEOS etc — causing 15+ min builds
    # or outright failures. Direct pip install uses pre-compiled wheels instead.
    system libexec/"bin/pip", "install", "--no-compile",
      "requests", "mapbox-vector-tile", "protobuf", "pyclipper", "shapely"

    # Install the app itself and link the binary
    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/ascii-map", "--help"
  end
end
