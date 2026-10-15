cask "notchy" do
  version "1.2"
  sha256 "b8ddf2e2722473a7199544b5045966f2bf536c27d2f4d6c2efec47dc80574a2c"

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
