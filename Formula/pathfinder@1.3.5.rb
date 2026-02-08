class PathfinderAT135 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.3.5"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.5/pathfinder-darwin-arm64.tar.gz"
      sha256 "22bcab7c10385617c3cf725052d28e13b4667cc1f45f56f69c50be615c656504"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.5/pathfinder-darwin-amd64.tar.gz"
      sha256 "b9c7bad7414b2779972207d26163056b360601ee92caf80b46bb253e2df574a8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.5/pathfinder-linux-arm64.tar.gz"
      sha256 "d83fc159ce6984aba76b576a14959b56ab4b30427d78535d4e8b95620bdbe4fe"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.5/pathfinder-linux-amd64.tar.gz"
      sha256 "48bc8377b5b6e8f2b990d0a731772ff18b36ec3a2cb4bfa3fb8e938e4b08233e"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/9d/32/60ba11b3d8d9b816a6cc0b3cb5ac686d9568442ad7b980e242ea3bbc671f/codepathfinder-1.3.5.tar.gz"
    sha256 "18c65ef39b9eba8a1bd976ea12393bf79ab55cdbaf2b6491344074cabc409acb"
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
      pathfinder@1.3.5 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.3.5 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.3.5/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
