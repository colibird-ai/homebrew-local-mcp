cask "local-mcp" do
  version "3.0.428"
  sha256 "89a4cfcd36c2070c82ddb7235bf06e5bf83af3179ef36dd8886fea056dcb6297"

  url "https://download.local-mcp.com/LocalMCP-#{version}.dmg"
  name "Local MCP"
  desc "MCP server connecting AI assistants to Mail, Calendar and local apps"
  homepage "https://local-mcp.com/"

  livecheck do
    url "https://office-mcp-production.up.railway.app/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: :ventura

  # 3.0.423 renamed the app inside the DMG to LMCP.app (bundle id and signing unchanged);
  # earlier DMGs still hold LocalMCPTray.app.
  app(Gem::Version.new(version) >= Gem::Version.new("3.0.423") ? "LMCP.app" : "LocalMCPTray.app")

  # The app migrates itself to LMCP.app on first launch, so an install made from an older cask
  # may now sit under either name; remove both. (The npx helper is also LMCP.app but lives in the
  # npm cache, never in /Applications.)
  uninstall launchctl: ["com.local-mcp.tray", "com.local-mcp.server"],
            quit:      "com.local-mcp.tray",
            delete:    ["/Applications/LMCP.app", "/Applications/LocalMCPTray.app"]

  # Same markers `npx local-mcp uninstall` writes (lmcp-npm index.js, uninstallSentinelPaths): with
  # either present the npx wrapper that AI clients still launch exits quietly instead of
  # reinstalling or looping. Written on uninstall and kept by zap (see below).
  uninstall_postflight do
    [
      "#{Dir.home}/.local/share/local-mcp/.uninstalled",
      "#{Dir.home}/Library/Application Support/Local MCP/.uninstalled",
    ].each do |marker|
      FileUtils.mkdir_p(File.dirname(marker))
      File.write(marker, (Time.now.to_f * 1000).to_i.to_s)
    end
  end

  # The two data folders are emptied with a glob, which skips dotfiles, so the `.uninstalled`
  # markers written above survive a zap.
  zap delete: [
        "~/.local/share/local-mcp/*",
        "~/Library/Application Support/Local MCP/*",
      ],
      trash:  [
        "~/Library/Caches/com.local-mcp.tray",
        "~/Library/LaunchAgents/com.local-mcp.server.plist",
        "~/Library/LaunchAgents/com.local-mcp.tray.plist",
        "~/Library/Preferences/com.local-mcp.tray.plist",
        "~/Library/Saved Application State/com.local-mcp.tray.savedState",
      ]
end
