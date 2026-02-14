class AsciiMap < Formula
  include Language::Python::Virtualenv

  desc "Terminal-based ASCII map explorer"
  homepage "https://github.com/Luthiraa/ascii-map"
  url "https://github.com/Luthiraa/ascii-map/archive/v0.1.2.tar.gz"
  sha256 "91a78815e0148500594e1cde40767747665f1fbdc11ce572af46c88584c63057"
  license "MIT"

  depends_on "python@3.11"
  depends_on "numpy"

  # Binary wheels with nounzip
  
  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e6/ad/3cc14f097111b4de0040c83a525973216457bbeeb63739ef1ed275c1c021/certifi-2026.1.4-py3-none-any.whl", using: :nounzip
    sha256 "9943707519e4add1115f44c2bc244f782c0249876bf51b6599fee1ffbedd685c"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ed/27/c6491ff4954e58a10f69ad90aca8a1b6fe9c5d3c6f380907af3c37435b59/charset_normalizer-3.4.4-cp311-cp311-macosx_10_9_universal2.whl", using: :nounzip
    sha256 "6e1fcf0720908f200cd21aa4e6750a48ff6ce4afe7ff5a79a90d5ed8a08296f8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/0e/61/66938bbb5fc52dbdf84594873d5b51fb1f7c7794e9c0f5bd885f30bc507b/idna-3.11-py3-none-any.whl", using: :nounzip
    sha256 "771a87f49d9defaf64091e6e6fe9c18d4833f140bd19464795bc32d966ca37ea"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/1e/db/4254e3eabe8020b458f1a747140d32277ec7a271daf1d235b70dc0b4e6e3/requests-2.32.5-py3-none-any.whl", using: :nounzip
    sha256 "2462f94637a34fd532264295e186976db0f5d453d1cdd31473c85a6a161affb6"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/39/08/aaaad47bc4e9dc8c725e68f9d04865dbcb2052843ff09c97b08904852d84/urllib3-2.6.3-py3-none-any.whl", using: :nounzip
    sha256 "bf272323e553dfb2e87d9bfd225ca7b0f467b919d7bbd355436d3fd37cb0acd4"
  end

  resource "mapbox-vector-tile" do
    url "https://files.pythonhosted.org/packages/50/79/cb2a50533c9c3b545eace2deffba0d002b56713c68b26b6ac1e53a4c1d18/mapbox_vector_tile-2.2.0-py3-none-any.whl", using: :nounzip
    sha256 "d26ad320ade60cc6c0b66edc6ee4b6f53663aedf0b444b115c6ba68e9ba1e6d1"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/57/bf/2086963c69bdac3d7cff1cc7ff79b8ce5ea0bec6797a017e1be338a46248/protobuf-6.33.5-py3-none-any.whl", using: :nounzip
    sha256 "69915a973dd0f60f31a08b8318b73eab2bd6a392c79184b3612226b0a3f8ec02"
  end

  resource "pyclipper" do
    url "https://files.pythonhosted.org/packages/de/e3/64cf7794319b088c288706087141e53ac259c7959728303276d18adc665d/pyclipper-1.4.0-cp311-cp311-macosx_10_9_universal2.whl", using: :nounzip
    sha256 "adcb7ca33c5bdc33cd775e8b3eadad54873c802a6d909067a57348bcb96e7a2d"
  end

  resource "shapely" do
    url "https://files.pythonhosted.org/packages/4f/ce/28fab8c772ce5db23a0d86bf0adaee0c4c79d5ad1db766055fa3dab442e2/shapely-2.1.2-cp311-cp311-macosx_11_0_arm64.whl", using: :nounzip
    sha256 "16a9c722ba774cf50b5d4541242b4cce05aafd44a015290c82ba8a16931ff63d"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11", system_site_packages: true)
    
    resources.each do |r|
      r.stage do
        if r.url.end_with?(".whl")
          # Copy wheel to current directory to ensure simple path
          cp r.cached_download, r.cached_download.basename
          # Install using --ignore-installed to bypass system packages errors
          system libexec/"bin/pip", "install", "--no-deps", "--no-compile", "--ignore-installed", r.cached_download.basename
        else
          system libexec/"bin/pip", "install", "--no-deps", "--no-compile", "--ignore-installed", "."
        end
      end
    end

    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/ascii-map", "--help"
  end
end
