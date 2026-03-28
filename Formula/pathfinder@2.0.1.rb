class PathfinderAT201 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "2.0.1"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.0.1/pathfinder-darwin-arm64.tar.gz"
      sha256 "eeb89f1704734e6606db9bdab56f093daf923b1ffc8f9af61330c2891ec2ed9a"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.0.1/pathfinder-darwin-amd64.tar.gz"
      sha256 "6e1724076ae110e304af24bcc59adebec041df82af3525a2540807c96e4492cd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.0.1/pathfinder-linux-arm64.tar.gz"
      sha256 "b7dcd9b4ed8867b9bb4bd6105e3ad9b97b56480b9157ef3c53dadfa3f1e180d6"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.0.1/pathfinder-linux-amd64.tar.gz"
      sha256 "c9aacd877d7353c6e4806be1838d534bbdad10bd501cbe1a1a48209320e453e1"
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
      pathfinder@2.0.1 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@2.0.1 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@2.0.1/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
