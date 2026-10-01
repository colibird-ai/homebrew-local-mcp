# Local MCP — Homebrew tap

Install [Local MCP](https://local-mcp.com) with Homebrew.

```sh
brew tap lanchuske/local-mcp
brew trust lanchuske/local-mcp
brew install --cask local-mcp
```

Recent versions of Homebrew refuse to load a cask from a third-party tap until you trust it; that is the second line. If your Homebrew does not have `brew trust`, skip it.

Then open **Local MCP** from Applications. It appears in your menu bar and configures your AI clients automatically.

## What it is

A native macOS MCP server that connects Claude Desktop, Claude.ai, ChatGPT, Cursor, VS Code, Windsurf and Zed to the apps you actually use — Mail, Calendar, Contacts, iMessage, Microsoft Teams, Slack, WhatsApp, OneDrive, Notes, Reminders, OmniFocus, Microsoft 365, Office documents and your local files.

The tools run on your Mac. No API keys, no tokens, no third-party service holding your data. Connecting a browser-based AI (claude.ai or ChatGPT on the web) additionally routes through an encrypted opt-in relay, which is never persisted server-side.

Free. Signed with a Developer ID and notarized by Apple.

## Requirements

- macOS 13 (Ventura) or later
- Apple silicon or Intel

## Updating

The app updates itself, so `brew upgrade` is not normally needed — the cask is marked `auto_updates true`. To move the Homebrew-recorded version forward anyway:

```sh
brew update && brew upgrade --cask local-mcp
```

## Uninstalling

```sh
brew uninstall --cask local-mcp
```

To also remove local configuration, caches and the LaunchAgent:

```sh
brew uninstall --zap --cask local-mcp
```

## Links

- Website: https://local-mcp.com
- Releases: https://github.com/lanchuske/local-mcp-releases
- npm: https://www.npmjs.com/package/local-mcp
