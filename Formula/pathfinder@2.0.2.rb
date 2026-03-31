class PathfinderAT202 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "2.0.2"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.0.2/pathfinder-darwin-arm64.tar.gz"
      sha256 "d3eca49cdb84baa6f87fc8eec83612320d5b77083946a14cc0b7b4c052fca463"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.0.2/pathfinder-darwin-amd64.tar.gz"
      sha256 "c004175e119e990cf4a96ae84788fd72312e8d7b12c752ce25a403777134fee1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.0.2/pathfinder-linux-arm64.tar.gz"
      sha256 "1f3c289515a9867fcd93a43e856faa1b1eeaeb6bf9f7e2b119079165e9679a8e"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v2.0.2/pathfinder-linux-amd64.tar.gz"
      sha256 "cebb55cbb6fd70d6618d189cf3eca2acceeae273bbd129b5495b655eff69dffa"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/57/45/0e3e31d3787809464641fc8b0f633c5ff06d25fffe39c5c681e8e1bf618d/codepathfinder-2.0.2.tar.gz"
    sha256 "4427106ee33e94405417f8f363ff7fb40ebf80ce7a3e21409a5fc2ec3d67bedd"
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
      pathfinder@2.0.2 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@2.0.2 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@2.0.2/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
