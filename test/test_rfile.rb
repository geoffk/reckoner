require 'test/unit'
require 'date'
require 'test/support'
require 'lib/main'

class RFileTest < Test::Unit::TestCase
  include BackupCheckSupport

  def setup
    makef(ROOT,[{:d1 => [:f1, :f2, :f3]},
                {:d2 => [{ :d3 => :f3 }, :f4]}])
    @cfile = RFile.new(ROOT)
  end

  def teardown
    rm_rf ROOT
  end

  def test_methods
    assert_equal @cfile.path, ROOT
    assert_equal @cfile.atime, File.atime(ROOT)
    assert_equal @cfile.mtime, File.mtime(ROOT)
    assert_equal @cfile.stat, File.stat(ROOT)
    assert_equal @cfile.basename, File.basename(ROOT)
    assert_equal @cfile.expand_path, File.expand_path(ROOT)
  end

  def test_recurse_functions
    assert_equal 9, @cfile.sub_node_array.length
    assert_equal 5, @cfile.sub_node_array(:directories => false).length
    assert_equal 4, @cfile.sub_node_array(:files => false).length

    assert @cfile.all_sub_nodes?{|f| f.basename.length == 2 || f.directory? } 
    assert @cfile.any_sub_node?{|f| f.basename == 'f3' } 
  end

end
