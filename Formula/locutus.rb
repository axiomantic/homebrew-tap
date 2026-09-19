class Locutus < Formula
  desc "Message exchange and routing for software agents over Redis without a background daemon"
  homepage "https://github.com/axiomantic/locutus"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/axiomantic/locutus/releases/download/v#{version}/locutus-darwin-arm64.tar.gz"
      sha256 "a83a8e197164401d88cbc4da914aa5eae770c82305eb330b0f1b620f09a2e30c"
    else
      url "https://github.com/axiomantic/locutus/releases/download/v#{version}/locutus-darwin-amd64.tar.gz"
      sha256 "a68c96430eec0567a0aad402ad168fb346494f5c8cc8b8da2d2cae07751962fd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/axiomantic/locutus/releases/download/v#{version}/locutus-linux-arm64.tar.gz"
      sha256 "9c1aca47a2e52bd5afd65cc78406166ca7800bd1481b4f92d6a9433fd5d6b4e4"
    else
      url "https://github.com/axiomantic/locutus/releases/download/v#{version}/locutus-linux-amd64.tar.gz"
      sha256 "d3e20527ef22f526a0f56e808f0a96c873a64be4164683ceed3e26ab3d30a7fb"
    end
  end

  head "https://github.com/axiomantic/locutus.git", branch: "main"

  depends_on "nim" => :build if build.head?
  depends_on "redis" => :recommended

  def install
    if build.head?
      system "nim", "c", "-d:release", "--opt:speed", "-o:bin/locutus", "src/locutus.nim"
      bin.install "bin/locutus"
    else
      bin.install "locutus"
    end
    pkgshare.install "skills" if File.exist?("skills")
  end

  def caveats
    <<~EOS
      To equip your AI coding assistants (Claude Code, Antigravity, OpenCode, Cursor):
        npx skills add axiomantic/locutus -g
        # Or using skilz:
        skilz install https://github.com/axiomantic/locutus
        # Or offline from local Homebrew files:
        npx skills add #{opt_pkgshare}/skills/locutus -g
    EOS
  end

  test do
    assert_match "Nim Native", shell_output("#{bin}/locutus --help")
  end
end
