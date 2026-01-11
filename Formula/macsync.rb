class Macsync < Formula
  desc "Easy sync for macOS. Dotfiles, folders, configs — anything"
  homepage "https://github.com/Pilaton/MacSync"
  url "https://github.com/Pilaton/MacSync/archive/refs/tags/MacSync-v2.0.1.tar.gz"
  sha256 "f1253f884446831677d2aefdcce93413662e15c7757b08f1ccaed0d40b5f840b"
  license "MIT"

  depends_on :macos

  def install
    # Install library files
    libexec.install Dir["lib/*"]
    
    # Install config template to correct location
    (prefix/"config").install "config/config.cfg.default"
    
    # Install VERSION file
    prefix.install "VERSION"
    
    # Update script to use prefix as root
    inreplace "bin/macsync",
      'MACSYNC_ROOT="${0:A:h:h}"',
      "MACSYNC_ROOT=\"#{prefix}\""
    
    bin.install "bin/macsync"
    
    # Create lib symlink for script to find modules
    (prefix/"lib").install_symlink Dir[libexec/"*"]
  end

  def caveats
    <<~EOS
      #{Tty.bold}#{Tty.cyan}════════════════════════════════════════════════════════════════#{Tty.reset}
      #{Tty.bold}📋 Configuration Required#{Tty.reset}
      #{Tty.bold}#{Tty.cyan}════════════════════════════════════════════════════════════════#{Tty.reset}

      #{Tty.bold}📝 Config file will be created automatically on first run:#{Tty.reset}
         #{Tty.cyan}~/.macsync/config.cfg#{Tty.reset}

      #{Tty.bold}⚙️  Edit it to configure:#{Tty.reset}
         • Sync folder (#{Tty.underline}SYNC_FOLDER#{Tty.reset})
         • Files to sync (#{Tty.underline}BACKUP_FILES#{Tty.reset})

      #{Tty.bold}📖 Full documentation:#{Tty.reset} #{homepage}

      #{Tty.bold}#{Tty.cyan}════════════════════════════════════════════════════════════════#{Tty.reset}
    EOS
  end

  test do
    assert_match "MacSync", shell_output("#{bin}/macsync --version")
  end
end
