class PathfinderAT122 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.2.2"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.2.2/pathfinder-darwin-arm64.tar.gz"
      sha256 "16d8c75322ef36e6df86fe2ff91154d25a4a4dcead14306be507a26e8c86a0ea"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.2.2/pathfinder-darwin-amd64.tar.gz"
      sha256 "495e416d0d4302f3b0553d9c941ac8f2c85beeb73d3c855d4d4b324b65ed0406"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.2.2/pathfinder-linux-arm64.tar.gz"
      sha256 "61e4e5d754841f01d137ed484ebf9de5dd66a3d0736ffa289bebd9833e090d81"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.2.2/pathfinder-linux-amd64.tar.gz"
      sha256 "2f4e868c57f55e6242fda16e0d4f9c26c99434ea83528e30fcfc706a72f91862"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/ac/88/57f2266499956e5521f6b6a5b95c7ea2a44c11c6ef4a4f85d095cadac249/codepathfinder-1.2.2.tar.gz"
    sha256 "2ef5ebede4da95deb0a283f0d8f42ed9701bd2a2fba13e6df04d4762609d80e2"
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
      pathfinder@1.2.2 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.2.2 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.2.2/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
