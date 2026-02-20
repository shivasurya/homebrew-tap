class PathfinderAT136 < Formula
  include Language::Python::Virtualenv

  desc "Open-source security suite with structural code analysis and AI-powered vulnerability detection"
  homepage "https://codepathfinder.dev/"
  license "AGPL-3.0-only"
  version "1.3.6"

  on_macos do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.6/pathfinder-darwin-arm64.tar.gz"
      sha256 "eeb584cf9941f7096897fd2c0cf100ccbb943711cb08ba0ea1d65d3260a65dea"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.6/pathfinder-darwin-amd64.tar.gz"
      sha256 "36ac8cfc43607cf1217e5af94458a045aa849cacad9c9902e80dd4d7114d559f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.6/pathfinder-linux-arm64.tar.gz"
      sha256 "bc0ceea90064e1b520659accf5a3fdb5a7e6a323cf4650396e11a6206ddc0d5a"
    end
    on_intel do
      url "https://github.com/shivasurya/code-pathfinder/releases/download/v1.3.6/pathfinder-linux-amd64.tar.gz"
      sha256 "c8ca64f87bc9c0b097daacf9b681891f4ce527d375c7eec92cb17df874550404"
    end
  end

  depends_on "python@3.12"

  resource "codepathfinder" do
    url "https://files.pythonhosted.org/packages/43/92/b20601c2818da64af753915b03819b833c8db48b2d7a8b7ff5d347ea16cc/codepathfinder-1.3.6.tar.gz"
    sha256 "3de865dc2fc04d7ceaccf1db13431513268d36f7593d8a2863be35ea7e02576e"
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
      pathfinder@1.3.6 is keg-only (versioned formula).

      To use this version, run:
        brew unlink pathfinder
        brew link pathfinder@1.3.6 --force

      Or run directly:
        $(brew --prefix)/opt/pathfinder@1.3.6/bin/pathfinder
    EOS
  end

  test do
    assert_match "Version:", shell_output("#{bin}/pathfinder version")
    system "#{libexec}/venv/bin/python", "-c", "import codepathfinder"
  end
end
