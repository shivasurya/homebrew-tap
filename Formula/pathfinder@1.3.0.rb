class PathfinderAT130 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.3.0"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.0/pathfinder-darwin-arm64.tar.gz"
      sha256 "bbc9caf61b200d97a1256f4a0a1396b78fddadb55b5a59bc16430112e5237eea"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.0/pathfinder-darwin-amd64.tar.gz"
      sha256 "ec9c77afab5f4153df85540989e1e3ce7b3b370f8e08ae4ffcb5b0a486a93544"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.0/pathfinder-linux-arm64.tar.gz"
      sha256 "64f7665d28c21e8709d1bf1d8c7a1e99ab14e32f26795666e6b4ceb7a96c41bb"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.0/pathfinder-linux-amd64.tar.gz"
      sha256 "025ae442f3798de9118594d11db061f7dc2e1740451d6f0b0572f4a11cf35485"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/35/5a/edbff53ffd431bf2852d55ebd00e7f5ecac7e6ab675f011cba5924ad0f16/codepathfinder-1.3.0.tar.gz"
    sha256 "0439fa9fec6aa2f12df910b7fc208930169cb1dd34819ae35cb17a4929eb69c6"
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
      pathfinder@1.3.0 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.3.0 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.3.0/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
