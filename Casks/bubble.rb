cask "bubble" do
  version "1.3"
  sha256 "2dabd36b00c888b0300fee7470ac5a0a37633322aa89f97b3da0917a571d37e3"

  url "https://github.com/Adityaadpandey/bubble/releases/download/v#{version}/Bubble.zip"
  name "Bubble"
  desc "Answers your terminal's prompts from the MacBook notch"
  homepage "https://github.com/Adityaadpandey/bubble"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Bubble.app"

  # Bubble isn't notarized by Apple yet, so without this macOS would refuse to open it the first time
  # and you'd have to find "Open Anyway" in System Settings. This is the same thing the curl installer does.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Bubble.app"],
        writable_paths: ["{{appdir}}/Bubble.app"]
  end

  uninstall quit: "dev.bubble.Bubble"

  zap trash: [
    "~/.config/bubble",
    "~/Library/Logs/Bubble.log",
    "~/Library/Preferences/dev.bubble.Bubble.plist",
  ]

  caveats <<~EOS
    If you clicked "Connect Claude Code", uninstalling leaves two hooks ending in
    "Bubble hook" in ~/.claude/settings.json. Remove them, or restore
    ~/.claude/settings.json.before-bubble.
  EOS
end
