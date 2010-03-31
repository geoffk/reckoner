require 'test/unit'
require 'date'
require 'test/support'
require 'lib/main'

class ReckonerTest < Test::Unit::TestCase
  include BackupCheckSupport

  def setup
    makef(ROOT,['one','two','three'], :atime => Time.now - d2s(10))
    @cm = Reckoner.new()
  end

  def teardown
    rm_rf ROOT
  end

  def test_non_existant_check
    assert_raise RuntimeError do
      @cm.check('test'=> {'files'=> File.join(ROOT,'one'), 'nocheck' => '20'})
    end
  end

  def test_multiple_files
    @cm.check('test'=> {'files'=> [File.join(ROOT,'one'), File.join(ROOT,'two')]})
    assert @cm.errors.empty?

    @cm.check('test'=> {'files'=> [File.join(ROOT,'one'), 
                                   File.join(ROOT,'blah'),
                                   File.join(ROOT,'two'),
                                   File.join(ROOT,'other'),
                                  ]})
    assert_equal 2, @cm.errors.length
    assert(/file does not exist/.match(@cm.errors[0]))
    assert(/file does not exist/.match(@cm.errors[1]))
  end

end
