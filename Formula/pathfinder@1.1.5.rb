class PathfinderAT115 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.1.5"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.5/pathfinder-darwin-arm64.tar.gz"
      sha256 "62b26edbe80fa856fad30cc9407a365a683a398633fe94d5c88d5b3681ffba45"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.5/pathfinder-darwin-amd64.tar.gz"
      sha256 "07cf3d16a36de515d4e6ed8822858ff1c5b63cb577c220b1780ad715ff052c58"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.5/pathfinder-linux-arm64.tar.gz"
      sha256 "62b10edb8d972fdf454329304649375ebb338e84b458bc893b004c6901afa2ff"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.5/pathfinder-linux-amd64.tar.gz"
      sha256 "7e044d993146214f00fac1ba9593b915da687431ac86ad02c6d499926b7b6cf7"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/42/2b/820c3cbe0c18c4440848eb750408d8c4cb87fc8968d89809f96c4901177d/codepathfinder-1.1.5.tar.gz"
    sha256 "67a7ab5028c2728bb2a53b341d8f4e5b32646f799fcb232e8d25eaf38e5cea5e"
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
      pathfinder@1.1.5 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.1.5 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.1.5/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
