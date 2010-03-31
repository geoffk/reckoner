require 'test/unit'
require 'date'
require 'test/support'

class SupportTest < Test::Unit::TestCase
  include BackupCheckSupport

  def test_makef
    makef(ROOT,[{'d1' => ['d1f1', 'd1f2', 'd1f3']},
                'f4',
                ['f5', 'f6', 'f7'],
                {'d2' => ['d2f1', 'd2f2']}])

    assert File.exists?(File.join(ROOT,'d1'))
    assert File.exists?(File.join(ROOT,'f4'))
    assert File.exists?(File.join(ROOT,'f5'))
    assert File.exists?(File.join(ROOT,'f6'))
    assert File.exists?(File.join(ROOT,'f7'))
    assert File.exists?(File.join(ROOT,'d1','d1f1'))
    assert File.exists?(File.join(ROOT,'d1','d1f2'))
    assert File.exists?(File.join(ROOT,'d1','d1f3'))
    assert File.exists?(File.join(ROOT,'d2'))
    assert File.exists?(File.join(ROOT,'d2','d2f1'))
    assert File.exists?(File.join(ROOT,'d2','d2f2'))
    rm_rf ROOT
  end

end
