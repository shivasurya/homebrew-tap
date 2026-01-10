class PathfinderAT116 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.1.6"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.6/pathfinder-darwin-arm64.tar.gz"
      sha256 "354b24d90389c729fbb0bd7df224b52cf414bdb1a15b8c29dda93215a23d0e34"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.6/pathfinder-darwin-amd64.tar.gz"
      sha256 "b434e3bc9cd5ae1bcf1e0c23bd228d7ea30c04535b3c89b954e36304eb4f8c7c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.6/pathfinder-linux-arm64.tar.gz"
      sha256 "01981e8e48fd11787f70434ae65d582a175d489d3bb55d78ceae160dad82d747"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.6/pathfinder-linux-amd64.tar.gz"
      sha256 "a1150148aff372b3295dc7a00e635fb7bcd9c380da4c882831a259fc8bf01491"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/3d/c9/ddc0f8cfc6aad0c81720a2c28b53cf95ffe1fd95c922374c09ff7acc6fa9/codepathfinder-1.1.6.tar.gz"
    sha256 "f7bbac006c7be8c85b42126717fcbd9021e76c37fbb9e8299b0fab08152bac05"
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
      pathfinder@1.1.6 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.1.6 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.1.6/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
