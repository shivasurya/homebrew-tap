class PathfinderAT0034 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "0.0.34"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v0.0.34/pathfinder-darwin-arm64.tar.gz"
      sha256 "d6c047b6e3ec6c0ef604b2cdaf0eecc8c8ff51de8d9e2a6a28383e3546a90c57"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v0.0.34/pathfinder-darwin-amd64.tar.gz"
      sha256 "8151bde1b98818369be29605682f81ee3164f31f1261e477d49560e36035590d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v0.0.34/pathfinder-linux-arm64.tar.gz"
      sha256 "57963000dc2a40b64ddc80a0dc595316e43eaf715e933194ca53f90a1c9b5e86"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v0.0.34/pathfinder-linux-amd64.tar.gz"
      sha256 "08b86d3d9254c4bdd5b9c130f6cdfe569fde07ca19fde8e4a186e4f7b9398942"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/63/cc/f63b9bc1dd53a13813520b45d1deeebfbec8aee19d397999219ead95ebe6/codepathfinder-1.0.0.tar.gz"
    sha256 "a04c7801a4ff001b5234b5a9d95ccece5f71d0d55a1af5e1c44405c98b38c912"
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
      pathfinder@0.0.34 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@0.0.34 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@0.0.34/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
