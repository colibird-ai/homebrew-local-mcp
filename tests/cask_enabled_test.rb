# Run: ruby tests/cask_enabled_test.rb   (no Homebrew needed)
# Homebrew is an install channel again (Darío, 2026-11-06), with the account required at the first
# launch. This replaces the retirement of #8: the cask installs, and the README says how.
require "minitest/autorun"

CASK_FILE = File.read(File.expand_path("../Casks/local-mcp.rb", __dir__))
README = File.read(File.expand_path("../README.md", __dir__))

class CaskEnabledTest < Minitest::Test
  def test_the_cask_is_neither_disabled_nor_deprecated
    refute_match(/^\s*(disable|deprecate)!/, CASK_FILE, "brew refuses to install a disabled cask")
  end

  def test_the_cask_names_a_published_version_and_its_checksum
    assert_match(/^  version "\d+\.\d+\.\d+"$/, CASK_FILE)
    assert_match(/^  sha256 "\h{64}"$/, CASK_FILE)
  end

  def test_the_readme_says_how_to_install_with_brew_and_that_the_account_comes_first
    assert_includes README, "brew install --cask local-mcp"
    assert_includes README, "brew tap colibird-ai/local-mcp"
    assert_match(/create your free LMCP account/, README)
    refute_match(/retired/i, README)
  end
end
