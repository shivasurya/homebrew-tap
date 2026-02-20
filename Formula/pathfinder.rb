class Pathfinder < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.3.6"

  # Platform-specific binary downloads
  # NOTE: Each tarball contains a file named "pathfinder"
  # SHA256 comments are used by automation for updates
  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v#{version}/pathfinder-darwin-arm64.tar.gz"
      sha256 "eeb584cf9941f7096897fd2c0cf100ccbb943711cb08ba0ea1d65d3260a65dea" # darwin-arm64
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v#{version}/pathfinder-darwin-amd64.tar.gz"
      sha256 "36ac8cfc43607cf1217e5af94458a045aa849cacad9c9902e80dd4d7114d559f" # darwin-amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v#{version}/pathfinder-linux-arm64.tar.gz"
      sha256 "bc0ceea90064e1b520659accf5a3fdb5a7e6a323cf4650396e11a6206ddc0d5a" # linux-arm64
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v#{version}/pathfinder-linux-amd64.tar.gz"
      sha256 "c8ca64f87bc9c0b097daacf9b681891f4ce527d375c7eec92cb17df874550404" # linux-amd64
    end
  end

  # Python dependency for DSL execution
  depends_on "python@3.12"

  # Python DSL package from PyPI
  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/43/92/b20601c2818da64af753915b03819b833c8db48b2d7a8b7ff5d347ea16cc/codepathfinder-1.3.6.tar.gz"
    sha256 "3de865dc2fc04d7ceaccf1db13431513268d36f7593d8a2863be35ea7e02576e" # pypi
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
