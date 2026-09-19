class Locutus < Formula
  desc "Message exchange and routing for software agents over Redis without a background daemon"
  homepage "https://github.com/axiomantic/locutus"
  version "0.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/axiomantic/locutus/releases/download/v#{version}/locutus-darwin-arm64.tar.gz"
      sha256 "6de61828b4acd9847bd37ce2f5cf2c9e2e6eccc0e9edf4db406ca4e1d2afa195"
    else
      url "https://github.com/axiomantic/locutus/releases/download/v#{version}/locutus-darwin-amd64.tar.gz"
      sha256 "11fd5c1590e00a3c9e48413b9d0979ef3b02d0f66717d92616e7a305a938abad"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/axiomantic/locutus/releases/download/v#{version}/locutus-linux-arm64.tar.gz"
      sha256 "fae788534c0412b45f68ffa607476aae96f133780a5385ebf0817dd9b068bec4"
    else
      url "https://github.com/axiomantic/locutus/releases/download/v#{version}/locutus-linux-amd64.tar.gz"
      sha256 "56fc2941c6269cea8a66e2079c3be340be0d6ddf6e008f097a0baeaf23cc42d4"
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
