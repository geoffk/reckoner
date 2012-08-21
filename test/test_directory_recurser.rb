require 'test/unit'
require 'date'
require 'test/support'
require 'lib/main'

class DirectoryRecurserTest < Test::Unit::TestCase
  include BackupCheckSupport

  def setup
    clean_root
  end

  def test_that_all_files_are_found
    makef(ROOT,{:d1 => [:f1, :f2, {:d2 => :f3}]})

    found = []
    DirectoryRecurser.find(File.join(ROOT,'d1')) do |f|
      found << File.basename(f)
    end
    assert_equal ['d1', 'd2', 'f1', 'f2', 'f3'], found.sort
  end

  def test_that_dir_are_returned_depth_first
    makef(ROOT,{:d1 => {:d2 => :f3}})

    found = []
    DirectoryRecurser.find(File.join(ROOT,'d1')) do |f|
      found << File.basename(f)
    end
    assert_equal ['f3', 'd2', 'd1'], found
  end

  def test_atime_sorting
    makef(ROOT,{:s => {:d1 => :f1}}, :atime => Time.now - 2000)
    makef(ROOT,{:s => {:d2 => :f2}}, :atime => Time.now)
    makef(ROOT,{:s => {:d3 => :f3}}, :atime => Time.now - 4000)

    found = []
    DirectoryRecurser.find(File.join(ROOT,'s'), :atime) do |f|
      found << File.basename(f)
    end
    assert_equal ['f2', 'd2', 'f1', 'd1', 'f3', 'd3', 's'], found
  end

  def test_alpha_sorting
    makef(ROOT,{:s => {:d1 => :f1}}, :atime => Time.now)
    makef(ROOT,{:s => {:d2 => :f2}}, :atime => Time.now - 2000)

    found = []
    DirectoryRecurser.find(File.join(ROOT,'s'), :alpha) do |f|
      found << File.basename(f)
    end
    assert_equal ['f1', 'd1', 'f2', 'd2', 's'], found
  end

end
