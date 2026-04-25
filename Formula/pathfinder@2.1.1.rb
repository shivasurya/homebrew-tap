class PathfinderAT211 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "2.1.1"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.1.1/pathfinder-darwin-arm64.tar.gz"
      sha256 "acb86fc35c0bf9d4b0f510abd0f687352916623f26959e25ea48d05f4939d3a4"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.1.1/pathfinder-darwin-amd64.tar.gz"
      sha256 "332f3f8faa3d23d1553eecdc3c748c3abb87abf25465d03784f1a70a7378515c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.1.1/pathfinder-linux-arm64.tar.gz"
      sha256 "f4e5c4a2831564c64e7abf0b663ce98720357586145e036919928d50d3a099df"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.1.1/pathfinder-linux-amd64.tar.gz"
      sha256 "132493f6972a5366c270b914895bb6a701029e326fa2e0380f4230eb670b4244"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/9f/eb/311ca304a62c8c6257d1a61cc7eb38d66182a0c2f39a3ef95233b43fe5c7/codepathfinder-2.1.1.tar.gz"
    sha256 "79d756b09678255f312f94d951d6136fde26e7747fff425aff3588a59975fed0"
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
      pathfinder@2.1.1 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@2.1.1 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@2.1.1/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
