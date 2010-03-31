require 'test/support'
require 'lib/main'
require 'test/unit'

class TestCheck < AbstractCheck
  check_name 'test_check'
end

class TestCheckTwo < AbstractCheck
end

class AbstractTest < Test::Unit::TestCase
  include BackupCheckSupport

  #Test that the name of a test is set correctly and
  #that it can be over-ridden.
  def test_abstract_check
    assert_equal 'test_check', TestCheck.get_check_name
    assert_equal 'test_check_two', TestCheckTwo.get_check_name

    tc2 = TestCheckTwo.new('.')
    assert tc2.is_a?(AbstractCheck)
  end

  def test_unit_parse
    uhash = { /^inch/ => 1, /^feet/ => 12, /^foot/ => 12, 'default' => 1 }
    ac = AbstractCheck.new(__FILE__)
    assert_equal 1, ac.unit_parse("1", uhash)
    assert_equal 1, ac.unit_parse("1 inch", uhash)
    assert_equal 1, ac.unit_parse("1inch", uhash)
    assert_equal 1.5, ac.unit_parse("1.5inch", uhash)
    assert_equal 12, ac.unit_parse("1 foot", uhash)
    assert_equal 24, ac.unit_parse("2 feet", uhash)
  end

end
