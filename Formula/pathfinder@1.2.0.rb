class PathfinderAT120 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.2.0"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.2.0/pathfinder-darwin-arm64.tar.gz"
      sha256 "dbf7b2927fa0751df47373246399015aa4adef525219dbbb72b0fca8cadcb36c"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.2.0/pathfinder-darwin-amd64.tar.gz"
      sha256 "3ae728cc83186f7f70a9e6647bc11b0b27848bef218c38836078bb7fb1e1ca26"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.2.0/pathfinder-linux-arm64.tar.gz"
      sha256 "88ba66a83a6b419d6ca60f4522556cab4162a2fe1857d06deef516df9a61f8d9"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.2.0/pathfinder-linux-amd64.tar.gz"
      sha256 "fa1ffcc78f510f3e72e0b9d3632e839433a81b9eccef0c5bbf8be44c1febf7c3"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/d1/3d/10068b3c84dd1c036e29b2210c0e2deb57e45d9dd4c66fefabe703b3c43b/codepathfinder-1.2.0.tar.gz"
    sha256 "8ac96c0b08a70bf3fc248d3e78dc4467a33813d31868ec78d2872a9721407399"
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
      pathfinder@1.2.0 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.2.0 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.2.0/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
