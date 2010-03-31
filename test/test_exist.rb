require 'test/support'
require 'lib/main'
require 'test/unit'

class ExistsTest < Test::Unit::TestCase
  include BackupCheckSupport

  def setup
    @root = '/tmp/test'
    makef(@root,['one','two','three'])
  end

  def teardown
    rm_rf @root
  end

  def test_files_exist
    cm = Reckoner.new()
    cm.check('test'=> {'files'=>'/tmp/test/one'})
    assert cm.errors.empty?

    cm.check('test'=> {'files'=>['/tmp/test/one','/tmp/test/two']})
    assert cm.errors.empty?
    
    cm.check('test'=> {'base_path'=>'/tmp/test','files'=>['one','two']})
    assert cm.errors.empty?
  end

  def test_errors
    cm = Reckoner.new(nil)
    cm.check('test'=>{'files'=>'nofile'})
    assert_equal 1,cm.errors.length
    assert has_error(cm,/does not exist/)
  end

end
