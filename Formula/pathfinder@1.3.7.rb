class PathfinderAT137 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.3.7"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.7/pathfinder-darwin-arm64.tar.gz"
      sha256 "6ee5d8562eb181e0cbfc8de75d4051e4195fc97b7ddf40607e136bbde681a3dd"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.7/pathfinder-darwin-amd64.tar.gz"
      sha256 "260a113ca0f7d098fcd3aabd31601383e74ed57450969fa3b8b57e3b958038f2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.7/pathfinder-linux-arm64.tar.gz"
      sha256 "34f5874e4fef34fca46ea801e26990c6839569a9f6a6a58563d81e83c5fa213b"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.7/pathfinder-linux-amd64.tar.gz"
      sha256 "98f1bb14b868215648a4fe1d13d67c1fefaa738eafa3e29dcb2e17f8eed94577"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/86/46/80747658d79e43fec9672c588deb037e70b7fa1ea3830ce74f60ba4fcda1/codepathfinder-1.3.7.tar.gz"
    sha256 "6ab53f2a4b4cbba37c07cd040c3555e9f48003ab2ed8c100572d80b910a9b892"
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
      pathfinder@1.3.7 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.3.7 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.3.7/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
