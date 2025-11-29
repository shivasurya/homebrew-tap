class PathfinderAT110 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.1.0"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.0/pathfinder-darwin-arm64.tar.gz"
      sha256 "d4cc7ba4fcfb53d02d07795c90b72d1233d2ff326c6eba159abeced7d963495e"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.0/pathfinder-darwin-amd64.tar.gz"
      sha256 "c6098a6ff384daf411caccd35976491fbe7011da299a76a1278e1b0e1d09069d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.0/pathfinder-linux-arm64.tar.gz"
      sha256 "dd2d6f56fbaf189c2a64c52b3533b61db2152b937d44046ebed9bc65e81188d6"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.0/pathfinder-linux-amd64.tar.gz"
      sha256 "9631ac07a2f1024d8fc500b4b3c72668220193b214b3a45b1e1cd854fc88f483"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/15/01/7bc2575f748c2b1671480806207b11de880766f53eb1b6b6ee07691dd821/codepathfinder-1.1.0.tar.gz"
    sha256 "1dd46b5e0dea5ff9518fe6ccab6b0a577fcd919c732eda48b6342131e41d0a6d"
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
      pathfinder@1.1.0 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.1.0 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.1.0/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
