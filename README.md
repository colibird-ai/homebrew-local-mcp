# Local MCP — Homebrew tap (retired)

**This tap no longer installs Local MCP.** The `local-mcp` cask was disabled on 2026-11-05.

Install [Local MCP](https://local-mcp.com) from the website:

- Download the app: https://www.local-mcp.com/download
- Or, from a terminal: `npx -y local-mcp@latest setup`

## If you installed it with Homebrew

The app keeps working and updates itself. Homebrew will show that the cask is disabled; uninstalling still works:

```sh
brew uninstall --cask local-mcp
```

The uninstall leaves the same `.uninstalled` markers as `npx local-mcp uninstall`, so an AI client that still launches the `npx local-mcp` wrapper gets a quiet exit instead of a reinstall. To also delete the app data (the markers are kept):

```sh
brew uninstall --zap --cask local-mcp
```

Then you can remove the tap with `brew untap colibird-ai/local-mcp`.

## Links

- Website: https://local-mcp.com
- npm: https://www.npmjs.com/package/local-mcp
