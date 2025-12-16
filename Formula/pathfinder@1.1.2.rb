class PathfinderAT112 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.1.2"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.2/pathfinder-darwin-arm64.tar.gz"
      sha256 "24a734d5ba69f27a15c0c5facf942fd4297e6173c446bd03bff7b94f6c59642f"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.2/pathfinder-darwin-amd64.tar.gz"
      sha256 "f901d5875c3b5a177561cd436f1253daeeeba31ecb209eee4293a744c08b1327"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.2/pathfinder-linux-arm64.tar.gz"
      sha256 "3bf8f50018461d6583c23c1b33e57b2edb4b5be4953ffd13efe8741b4ed375b6"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.2/pathfinder-linux-amd64.tar.gz"
      sha256 "a47bf9b5f1bdca9eb53ef691e91da23d736a43e599e223c76aa924d9d410d189"
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
      pathfinder@1.1.2 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.1.2 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.1.2/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
