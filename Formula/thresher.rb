class Thresher < Formula
  include Language::Python::Virtualenv

  desc "AI-powered supply chain security scanner for open source packages"
  homepage "https://github.com/thresher-sh/thresher"
  url "https://github.com/thresher-sh/thresher/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "19791a2d567e79e9298de740519ca9442615f6ddc50cfc2b14d095393c62c905"
  license "MIT"

  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "lima" => :recommended

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources

    # Install data directories that the Python package references at runtime
    # (lima template, VM provisioning scripts, scanner rules, Docker context).
    # The Python code looks for these under sys.prefix/share/thresher/.
    pkgshare = libexec/"share"/"thresher"
    (pkgshare/"lima").install "lima/thresher.yaml"
    pkgshare.install "vm_scripts"
    pkgshare.install "rules"
    pkgshare.install "docker"
  end

  def caveats
    <<~EOS
      Lima is required to run thresher scans. If not already installed:
        brew install lima

      Before your first scan, provision the VM:
        thresher build
    EOS
  end

  test do
    assert_match "supply chain security scanner", shell_output("#{bin}/thresher --help")
  end
end
