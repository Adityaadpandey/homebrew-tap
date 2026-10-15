cask "notchy" do
  version "1.0"
  sha256 "af5149ef0d53c43035fa9ae68714d02d47f9ecbf9a4c419deb7516cad3458938"

  url "https://github.com/Adityaadpandey/notchy/releases/download/v#{version}/Notchy.zip"
  name "Notchy"
  desc "Answers your terminal's prompts from the MacBook notch"
  homepage "https://github.com/Adityaadpandey/notchy"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Notchy.app"

  # Notchy isn't notarized by Apple yet, so without this macOS would refuse to open it the first time
  # and you'd have to find "Open Anyway" in System Settings. This is the same thing the curl installer does.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Notchy.app"],
        writable_paths: ["{{appdir}}/Notchy.app"]
  end

  uninstall quit: "dev.notchy.Notchy"

  zap trash: [
    "~/.config/notchy",
    "~/Library/Logs/Notchy.log",
    "~/Library/Preferences/dev.notchy.Notchy.plist",
  ]

  caveats <<~EOS
    If you clicked "Connect Claude Code", uninstalling leaves two hooks ending in
    "Notchy hook" in ~/.claude/settings.json. Remove them, or restore
    ~/.claude/settings.json.before-notchy.
  EOS
end
