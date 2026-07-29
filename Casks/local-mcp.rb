cask "local-mcp" do
  version "3.0.354"
  sha256 "b4a66c32f0bcdedffaf796c7013d2d59a18d8436397bacfc5562aaed81400b2e"

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

  uninstall launchctl: "com.local-mcp.tray",
            quit:      "com.local-mcp.tray"

  zap trash: [
    "~/.local/share/local-mcp",
    "~/Library/Application Support/Local MCP",
    "~/Library/Caches/com.local-mcp.tray",
    "~/Library/LaunchAgents/com.local-mcp.tray.plist",
    "~/Library/Preferences/com.local-mcp.tray.plist",
    "~/Library/Saved Application State/com.local-mcp.tray.savedState",
  ]
end
