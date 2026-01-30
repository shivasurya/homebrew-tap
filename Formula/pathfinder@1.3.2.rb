class PathfinderAT132 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.3.2"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.2/pathfinder-darwin-arm64.tar.gz"
      sha256 "0222d9a49baed23c73105533435d1801533d272964055fe8405579eac09c7598"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.2/pathfinder-darwin-amd64.tar.gz"
      sha256 "f676feba1b7b8fac7ad3ac3b4343396361aea4ac1f9103faa6585b095345125a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.2/pathfinder-linux-arm64.tar.gz"
      sha256 "d0905864e4301c2df180939028f09bc8d47a89e8d02ac54d8948528d6f03a2ad"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.2/pathfinder-linux-amd64.tar.gz"
      sha256 "ceb7cb86d7801e9ff78fb827fe046b582c5afb35b43017a959cdba5599936c83"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/09/b6/ecd1d852c6e16b2eb30057bc824d3b91f7ddc1c55dff1c7310670e29ffb3/codepathfinder-1.3.2.tar.gz"
    sha256 "eb84b11ed3985153f3ffee238fd50fb011eef445fc60930dbdf4a00ad06a97b7"
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
      pathfinder@1.3.2 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.3.2 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.3.2/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
