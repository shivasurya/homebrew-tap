class PathfinderAT134 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.3.4"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.4/pathfinder-darwin-arm64.tar.gz"
      sha256 "11189559c22cb47b71a801b8c464d9de5fee0c813cfeab243c60a393dbe31b3c"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.4/pathfinder-darwin-amd64.tar.gz"
      sha256 "2fcec20817d4a899adea885991b174870af57f6a64e201ecac27242d2a1fb1db"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.4/pathfinder-linux-arm64.tar.gz"
      sha256 "6578017ac176f0c70a9d2b855a3e1aba59aecfbaa8783fc5ede37f57cd8171d1"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.4/pathfinder-linux-amd64.tar.gz"
      sha256 "92986e21397222d5b2260ebaf38748f73af52e8f1f3f6e4d0685de47c9fdaa44"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/a3/08/918bae865a7429e0d94fc1279877c982a9a79d0c2d6485217a800ebd0e9b/codepathfinder-1.3.4.tar.gz"
    sha256 "209b522f511b3af16f41bc6456e8253f8406f7bc2dc48216404333f3e0decb79"
  end

  keg_only :versioned_formula

  def install
    libexec.install "pathfinder"
    venv = virtualenv_create(libexec/"venv")
    venv.pip_install resource("codepathfinder")
    (bin/"pathfinder").write_env_script(
      libexec/"pathfinder",
      PATH: "#{venv.root}/bin:#{ENV["PATH"]}"
    )
  end

  def caveats
    <<~EOS
      pathfinder@1.3.4 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.3.4 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.3.4/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
