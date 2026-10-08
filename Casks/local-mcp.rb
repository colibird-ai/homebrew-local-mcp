cask "local-mcp" do
  version "3.0.420"
  sha256 "b4a0c9273f0cf537b3ef1b7186ffc5086879d9ad8801a59f86b18cbcf568508e"

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

  app "LocalMCPTray.app"

  uninstall launchctl: ["com.local-mcp.tray", "com.local-mcp.server"],
            quit:      "com.local-mcp.tray"

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
