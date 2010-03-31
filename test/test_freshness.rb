require 'test/unit'
require 'date'
require 'test/support'
require 'lib/main'

class FreshnessTest < Test::Unit::TestCase
  include BackupCheckSupport

  def setup
    makef(ROOT,['one','two','three', 
                 {'dir' => ['four','five']}], :atime => Time.now - d2s(10))
    makef(ROOT,'six', :atime => Time.now - d2s(1))
    @cm = Reckoner.new()
  end

  def teardown
    rm_rf ROOT
  end

  def test_single_file_success
    @cm.check('test'=> {'files'=>File.join(ROOT,'one'), 'freshness' => '20'})
    assert @cm.errors.empty?

    @cm.check('test'=> {'files'=>File.join(ROOT,'six'), 'freshness' => '30 hours'})
    assert @cm.errors.empty?
  end

  def test_single_file_failure
    @cm.check('test'=> {'files'=>File.join(ROOT,'one'), 'freshness' => '5'})
    assert_equal 1, @cm.errors.length
    assert has_error(@cm,/file is too old/)
  end

  def test_hour_failure
    @cm.check('test'=> {'files'=>File.join(ROOT,'six'), 'freshness' => '22 hours'})
    assert_equal 1, @cm.errors.length
    assert has_error(@cm,/file is too old/)
  end

  def test_recursive_success
    hundred_days_ago = Time.now - d2s(100)
    File.utime(hundred_days_ago,hundred_days_ago,ROOT)
    assert_equal File.mtime(ROOT).to_s,hundred_days_ago.to_s
    
    @cm.check('test'=> {'files'=>ROOT, 'freshness' => '20'})
    assert @cm.errors.empty?
  end

end