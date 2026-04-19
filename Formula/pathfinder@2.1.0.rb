class PathfinderAT210 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "2.1.0"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.1.0/pathfinder-darwin-arm64.tar.gz"
      sha256 "3b41425dc256d92f75aa5f5e03cbc441b89f1be6d4a1ead67224e8de37dc9174"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.1.0/pathfinder-darwin-amd64.tar.gz"
      sha256 "bca9626f08b497005a74df32656cabb3f3cc2dde90fc7cde5a74a02a115de44b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.1.0/pathfinder-linux-arm64.tar.gz"
      sha256 "fadc8d844bd9ecf58a08bc8d0590984867f0c30659181d1e8b15a52129e01e2c"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.1.0/pathfinder-linux-amd64.tar.gz"
      sha256 "dae1773411a420db249732936534d009d2011fedaf00ab4a9f877bb2a8b2a23a"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/66/ad/5a6bc2a14c61b946491f1c821aa26fb7655344f74238a0008118fcdca075/codepathfinder-2.1.0.tar.gz"
    sha256 "9b62817a8f6797d7a669b02daf314a5e9a2aea98c83146fb4d7437405a021137"
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
      pathfinder@2.1.0 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@2.1.0 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@2.1.0/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
