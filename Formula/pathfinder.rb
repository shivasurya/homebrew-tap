class Pathfinder < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.3.4"

  # Platform-specific binary downloads
  # NOTE: Each tarball contains a file named "pathfinder"
  # SHA256 comments are used by automation for updates
  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v#{version}/pathfinder-darwin-arm64.tar.gz"
      sha256 "11189559c22cb47b71a801b8c464d9de5fee0c813cfeab243c60a393dbe31b3c" # darwin-arm64
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v#{version}/pathfinder-darwin-amd64.tar.gz"
      sha256 "2fcec20817d4a899adea885991b174870af57f6a64e201ecac27242d2a1fb1db" # darwin-amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v#{version}/pathfinder-linux-arm64.tar.gz"
      sha256 "6578017ac176f0c70a9d2b855a3e1aba59aecfbaa8783fc5ede37f57cd8171d1" # linux-arm64
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v#{version}/pathfinder-linux-amd64.tar.gz"
      sha256 "92986e21397222d5b2260ebaf38748f73af52e8f1f3f6e4d0685de47c9fdaa44" # linux-amd64
    end
  end

  # Python dependency for DSL execution
  depends_on "python@3.12"

  # Python DSL package from PyPI
  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/a3/08/918bae865a7429e0d94fc1279877c982a9a79d0c2d6485217a800ebd0e9b/codepathfinder-1.3.4.tar.gz"
    sha256 "209b522f511b3af16f41bc6456e8253f8406f7bc2dc48216404333f3e0decb79" # pypi
  end

  def install
    # Install Go binary into libexec (wrapper goes in bin)
    libexec.install "pathfinder"

    # Create Python virtualenv with DSL package
    venv = virtualenv_create(libexec/"venv")
    venv.pip_install resource("codepathfinder")

    # Create wrapper script that adds venv to PATH
    # This ensures `python3` finds the venv interpreter with codepathfinder installed
    (bin/"pathfinder").write_env_script(
      libexec/"pathfinder",
      PATH: "#{venv.root}/bin:#{ENV["PATH"]}"
    )
  end

  def caveats
    <<~EOS
      Code Pathfinder has been installed!

      Quick start:
        pathfinder scan --project /path/to/your/code --rules /path/to/rules

      For Python DSL rules, the codepathfinder package is pre-installed.

      Documentation: https://codepathfinder.dev/
    EOS
  end

  test do
    # Test binary runs and outputs version
    assert_match "Version:", shell_output("#{bin}/pathfinder version")

    # Test Python DSL package is available
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder; print(codepathfinder.__version__)"
  end
end
