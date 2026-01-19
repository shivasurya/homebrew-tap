class Pathfinder < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.2.1"

  # Platform-specific binary downloads
  # NOTE: Each tarball contains a file named "pathfinder"
  # SHA256 comments are used by automation for updates
  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v#{version}/pathfinder-darwin-arm64.tar.gz"
      sha256 "788b314d12742c7ce18fc7baaf04ead1b5aa12d597c7df50c6ef784a8598def4" # darwin-arm64
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v#{version}/pathfinder-darwin-amd64.tar.gz"
      sha256 "5db650b4f843740e91bd8ab79b5f9c017c2504cc6e57c0fea9ab66f39603d843" # darwin-amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v#{version}/pathfinder-linux-arm64.tar.gz"
      sha256 "535274ff7c4e028d58249f103073f84d4ba7a524c4a195ec7e867e55acb4e424" # linux-arm64
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v#{version}/pathfinder-linux-amd64.tar.gz"
      sha256 "88ee8778bbe5165943bfc4290446c67b150f252ec37c25bde2d73a3a84c9bd62" # linux-amd64
    end
  end

  # Python dependency for DSL execution
  depends_on "python@3.12"

  # Python DSL package from PyPI
  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/64/69/74d0c5b0b407f7b32b9d379e602dcf39ea908d1534ca6388611e4d229e4b/codepathfinder-1.2.1.tar.gz"
    sha256 "831213c23413e7ab08eaaee602b7bcd9872ac55f2547cdbbfacfdb3dc4f00069" # pypi
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
