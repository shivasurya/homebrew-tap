class PathfinderAT121 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.2.1"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.2.1/pathfinder-darwin-arm64.tar.gz"
      sha256 "788b314d12742c7ce18fc7baaf04ead1b5aa12d597c7df50c6ef784a8598def4"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.2.1/pathfinder-darwin-amd64.tar.gz"
      sha256 "5db650b4f843740e91bd8ab79b5f9c017c2504cc6e57c0fea9ab66f39603d843"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.2.1/pathfinder-linux-arm64.tar.gz"
      sha256 "535274ff7c4e028d58249f103073f84d4ba7a524c4a195ec7e867e55acb4e424"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.2.1/pathfinder-linux-amd64.tar.gz"
      sha256 "88ee8778bbe5165943bfc4290446c67b150f252ec37c25bde2d73a3a84c9bd62"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/64/69/74d0c5b0b407f7b32b9d379e602dcf39ea908d1534ca6388611e4d229e4b/codepathfinder-1.2.1.tar.gz"
    sha256 "831213c23413e7ab08eaaee602b7bcd9872ac55f2547cdbbfacfdb3dc4f00069"
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
      pathfinder@1.2.1 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.2.1 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.2.1/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
