class PathfinderAT114 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.1.4"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.4/pathfinder-darwin-arm64.tar.gz"
      sha256 "0e9a9005074349262ee7fcfb25de4eeab66693001e72e443b93b9c69df7e71bc"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.4/pathfinder-darwin-amd64.tar.gz"
      sha256 "46ba569bfc90408354c1c16f76b02184599535b3d9827f47951548a42fab70ca"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.4/pathfinder-linux-arm64.tar.gz"
      sha256 "76a647613d8f7900ffcdbb75bad40d9c7604880f454e12c76c97f6ae34cd6581"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.4/pathfinder-linux-amd64.tar.gz"
      sha256 "bc9bd5b8582d22ad98a2f65afaa3b8ff8e6c9a09e2c4964fddf1fc80a9b244d2"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/33/6d/2ee3d6d1c70b9ecd2cd22b098cf6364d9ef998e705e4ed7415b03c00b437/codepathfinder-1.1.2.tar.gz"
    sha256 "2155e03f6843293474eadbd22717d61c84334d94ee6daa7027fd07a438df379e"
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
      pathfinder@1.1.4 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.1.4 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.1.4/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
