class Pathfinder < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.3.7"

  # Platform-specific binary downloads
  # NOTE: Each tarball contains a file named "pathfinder"
  # SHA256 comments are used by automation for updates
  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v#{version}/pathfinder-darwin-arm64.tar.gz"
      sha256 "6ee5d8562eb181e0cbfc8de75d4051e4195fc97b7ddf40607e136bbde681a3dd" # darwin-arm64
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v#{version}/pathfinder-darwin-amd64.tar.gz"
      sha256 "260a113ca0f7d098fcd3aabd31601383e74ed57450969fa3b8b57e3b958038f2" # darwin-amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v#{version}/pathfinder-linux-arm64.tar.gz"
      sha256 "34f5874e4fef34fca46ea801e26990c6839569a9f6a6a58563d81e83c5fa213b" # linux-arm64
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v#{version}/pathfinder-linux-amd64.tar.gz"
      sha256 "98f1bb14b868215648a4fe1d13d67c1fefaa738eafa3e29dcb2e17f8eed94577" # linux-amd64
    end
  end

  # Python dependency for DSL execution
  depends_on "python@3.12"

  # Python DSL package from PyPI
  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/86/46/80747658d79e43fec9672c588deb037e70b7fa1ea3830ce74f60ba4fcda1/codepathfinder-1.3.7.tar.gz"
    sha256 "6ab53f2a4b4cbba37c07cd040c3555e9f48003ab2ed8c100572d80b910a9b892" # pypi
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
