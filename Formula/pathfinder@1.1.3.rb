class PathfinderAT113 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.1.3"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.3/pathfinder-darwin-arm64.tar.gz"
      sha256 "a7b61dd009864dd49bf5bcdf575300b2a3a941fa702932fc9d3588d6bd92b1bd"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.3/pathfinder-darwin-amd64.tar.gz"
      sha256 "b0c7ac143f390b0f778f009d39053f6d9f3440ab94d36ac22f125666cfd54b55"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.3/pathfinder-linux-arm64.tar.gz"
      sha256 "3cebb4c824d49bf7cc56674be003a01dff78d79bca759769f5ba7b2f040b2409"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.1.3/pathfinder-linux-amd64.tar.gz"
      sha256 "350eaed12db05b9673fecb28011c7166b4c0a361683df21c4c34be7bf863c32c"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/33/6d/2ee3d6d1c70b9ecd2cd22b098cf6364d9ef998e705e4ed7415b03c00b437/codepathfinder-1.1.2.tar.gz"
    sha256 "2155e03f6843293474eadbd22717d61c84334d94ee6daa7027fd07a438df379e"
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
      pathfinder@1.1.3 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.1.3 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.1.3/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
