# Run: ruby tests/uninstall_markers_test.rb   (no Homebrew needed; uses a temp HOME, never the real one)
require "tmpdir"
require "fileutils"
require "minitest/autorun"

CASK = File.read(File.expand_path("../Casks/local-mcp.rb", __dir__))

class UninstallMarkersTest < Minitest::Test
  def with_home
    Dir.mktmpdir do |home|
      old = ENV["HOME"]
      ENV["HOME"] = home
      yield home
    ensure
      ENV["HOME"] = old
    end
  end

  def postflight_body
    CASK[/uninstall_postflight do\n(.*?)\n  end\n/m, 1] or flunk "cask has no uninstall_postflight"
  end

  def test_uninstall_writes_both_markers_npx_uninstall_writes
    with_home do |home|
      eval(postflight_body) # rubocop:disable Security/Eval
      %w[.local/share/local-mcp Library/Application\ Support/Local\ MCP].each do |d|
        assert File.file?(File.join(home, d, ".uninstalled")), "missing marker in #{d}"
      end
    end
  end

  def test_zap_globs_skip_the_markers_and_cover_data
    with_home do |home|
      dirs = [".local/share/local-mcp", "Library/Application Support/Local MCP"].map { |d| File.join(home, d) }
      dirs.each do |d|
        FileUtils.mkdir_p(d)
        File.write(File.join(d, ".uninstalled"), "1")
        File.write(File.join(d, "data.db"), "x")
      end
      globs = CASK[/zap delete: \[(.*?)\]/m, 1].scan(/"~\/([^"]+)"/).flatten
      assert_equal 2, globs.size
      globs.each { |g| Dir.glob(File.join(home, g)).each { |f| FileUtils.rm_rf(f) } }
      dirs.each do |d|
        assert File.file?(File.join(d, ".uninstalled")), "zap removed the marker in #{d}"
        refute File.exist?(File.join(d, "data.db")), "zap left data in #{d}"
      end
    end
  end

  def test_server_launch_agent_is_unloaded_and_removed
    assert_match(/launchctl: \[[^\]]*com\.local-mcp\.server/, CASK)
    assert_includes CASK, "~/Library/LaunchAgents/com.local-mcp.server.plist"
  end
end
