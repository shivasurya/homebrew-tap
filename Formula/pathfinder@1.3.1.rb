class PathfinderAT131 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.3.1"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.1/pathfinder-darwin-arm64.tar.gz"
      sha256 "d5bf8fb6cdb84af920fe0a15531de8293fa9b8889b27e192eb8a18b91de7df12"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.1/pathfinder-darwin-amd64.tar.gz"
      sha256 "fbedd89a1a07988a921974c8977c4f58abc98dcbe3177d7f4f8a2096b7919983"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.1/pathfinder-linux-arm64.tar.gz"
      sha256 "2e5b00fc07b67953a28058255af077efbafddc0684499795b6dbf1666331b215"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.1/pathfinder-linux-amd64.tar.gz"
      sha256 "307b4f7e5728125a88eff484bac80e223599bb5fbeebbabc7e4e8c09acfbd112"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/59/61/9951b296059a53b87136b1a829954361e0977ea450754be141fa2681a15c/codepathfinder-1.3.1.tar.gz"
    sha256 "1820e44a9cba4b0b049b78dff0f78ae2bf01b1b0876634414370d7dc1de05cbb"
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
      pathfinder@1.3.1 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.3.1 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.3.1/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
