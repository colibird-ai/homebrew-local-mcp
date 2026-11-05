# Run: ruby tests/disabled_test.rb   (no Homebrew needed)
# The cask is retired (2026-11-05): LMCP installs from the website or with npx. The file stays so anyone who
# already has the cask gets a clear message instead of an error.
require "minitest/autorun"

CASK_RETIRED = File.read(File.expand_path("../Casks/local-mcp.rb", __dir__))

class DisabledTest < Minitest::Test
  def test_cask_is_disabled_with_the_new_way_to_install
    stanza = CASK_RETIRED[/^  disable! date: +"2026-11-05",\n +because: +((?:"[^"]*"(?: \\\n +)?)+)$/, 1]
    refute_nil stanza, "the cask must be disabled on 2026-11-05"
    line = stanza.scan(/"([^"]*)"/).join
    assert_includes line, "https://www.local-mcp.com/download"
    assert_includes line, "npx -y local-mcp@latest setup"
  end

  def test_readme_no_longer_tells_anyone_to_install_with_brew
    readme = File.read(File.expand_path("../README.md", __dir__))
    refute_match(/\bbrew (install|tap|trust)\b/, readme)
    assert_includes readme, "https://www.local-mcp.com/download"
    assert_includes readme, "npx -y local-mcp@latest setup"
  end
end
