class PathfinderAT133 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.3.3"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.3/pathfinder-darwin-arm64.tar.gz"
      sha256 "02a9a9b31b2c715af9151aadced7289d02b56d55392f593edbbf4d13558bd236"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.3/pathfinder-darwin-amd64.tar.gz"
      sha256 "ede8bde4c30936631c189327db4e9e70e023e487d78cfc2a11127b372049e666"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.3/pathfinder-linux-arm64.tar.gz"
      sha256 "65674e3b3026ae3288ee9a19ff0f39c8da13f21f5d581d6f99fc95211fd587ad"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.3/pathfinder-linux-amd64.tar.gz"
      sha256 "e1edcfe58f5b77fd418ce1f2a578c69cf43174ba57104e5114c68155db0223dd"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/4b/b6/6526cd2489b398433baf44e7ea200f2a018784737b000309efd84ce60559/codepathfinder-1.3.3.tar.gz"
    sha256 "f8fe27dd4679f12cade4d8f0e13a65165d3829f3bb528c04147269e2bf94a599"
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
      pathfinder@1.3.3 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.3.3 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.3.3/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
