require 'test/unit'
require 'memfs'
require 'fileutils'

class TestMemfs < Test::Unit::TestCase
  def test_single_mkdir
    dir = '/test'
    MemFs.activate do
      FileUtils.mkdir(dir)
      assert_true(File.directory?(dir))
    end
    assert_false(File.directory?(dir))
  end

  def test_list_mkdir
    dirs = %w[/test1 /test2]
    MemFs.activate do
      FileUtils.mkdir(dirs)
      dirs.each do |dir|
        assert_true(File.directory?(dir))
      end
    end
    dirs.each do |dir|
      assert_false(File.directory?(dir))
    end
  end

  def test_rmdir
    dir = '/test1'
    MemFs.activate do
      FileUtils.mkdir(dir)
      FileUtils.rmdir(dir)
      assert_false(File.directory?(dir))
    end
  end

  def test_ln_s
    MemFs.activate do
      dir = '/tmp/test1'
      link = '/tmp/test1_link'
      FileUtils.mkdir(dir)
      FileUtils.ln_s(dir, link)
      assert_true(File.symlink?(link))
    end
  end

  def test_chmod
    MemFs.activate do
      dir = '/tmp/test1'
      FileUtils.mkdir(dir, mode: 0o755)
      stat = File.stat(dir)
      assert_equal(0o100755, stat.mode)

      FileUtils.chmod(0o644, dir)
      stat = File.stat(dir)
      assert_equal(0o100644, stat.mode)
    end
  end
end
