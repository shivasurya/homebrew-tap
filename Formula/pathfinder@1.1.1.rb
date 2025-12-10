class PathfinderAT111 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.1.1"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.1/pathfinder-darwin-arm64.tar.gz"
      sha256 "6f71890f174db0f3343e311645fb668566b4faeebcc8bdd5f4b547c67433a831"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.1/pathfinder-darwin-amd64.tar.gz"
      sha256 "038f47cb41ed3d9169197a21fcc5c898bf309f54841e1ce6e0cbbd79923907be"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.1/pathfinder-linux-arm64.tar.gz"
      sha256 "271d59c1858f7b6aa4c00c75cd58b9ee1642db1fed2f04b326f68d54b04d7bbc"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.1/pathfinder-linux-amd64.tar.gz"
      sha256 "d855fb9cea3e4e62e4e2c06f82fe4ac0f788c527d4fde62050bb1d0e8b6ac5da"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/70/d8/92e80b8cd7212e7f1cf143233db49958d6fc7602159f3cec328a7f5339ed/codepathfinder-1.1.1.tar.gz"
    sha256 "86e3bf6d34255abfef3c760a89fb5ee12f16e5cc9cad09404cda5f024052c06c"
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
      pathfinder@1.1.1 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.1.1 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.1.1/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
