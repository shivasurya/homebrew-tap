class PathfinderAT200 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "2.0.0"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.0.0/pathfinder-darwin-arm64.tar.gz"
      sha256 "4f4e7b7270587d1167841fdbdb824c48ec0ec6a00c924ecd32ea2e633378cd43"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.0.0/pathfinder-darwin-amd64.tar.gz"
      sha256 "2ba1ee98c580463bcb86a157fa9cc4185d428fea9309045a873c960d9eef9e28"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.0.0/pathfinder-linux-arm64.tar.gz"
      sha256 "bda4b7bfe21544713352b52527c36deceb57ea5447713ea5002535dd41b6e967"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.0.0/pathfinder-linux-amd64.tar.gz"
      sha256 "5916f2a666ae45008d1324f427a716799172982eb6239952bcc0a8c0db62a0c5"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/c7/50/1ea888e396dcb27dda7ea59a556d7fc1ca873415cba5765bef12d1e72805/codepathfinder-2.0.0.tar.gz"
    sha256 "55ff3d578ec5780982339252c0676ced97ea39a9c5bf05962ff4149151961e8e"
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
      pathfinder@2.0.0 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@2.0.0 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@2.0.0/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
