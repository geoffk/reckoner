require 'test/unit'
require 'date'
require 'test/support'
require 'lib/main'

class MinimumSizeTest < Test::Unit::TestCase
  include BackupCheckSupport

  def setup
    @cm = Reckoner.new()
    @bin = File.join('test','files','one-k.bin')
  end

  def test_file_right_size
    @cm.check('test'=> {'files'=>@bin, 'minimum_size' => '1'})
    assert @cm.errors.empty?
  end

  def test_file_too_small
    @cm.check('test'=> {'files'=>@bin, 'minimum_size' => '2048'})
    assert_equal 1, @cm.errors.length
    assert has_error(@cm,/file is too small/)
  end

  def kilobyte_parsing
    @cm.check('test'=> {'files'=>@bin, 'minimum_size' => '1kb'})
    assert @cm.errors.empty?

    @cm.check('test'=> {'files'=>@bin, 'minimum_size' => '2kb'})
    assert_equal 1, @cm.errors.length
    assert has_error(@cm,/file is too small/)
  end
end
