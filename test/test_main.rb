require 'test/unit'
require 'date'
require 'test/support'
require 'lib/main'

class MainTest < Test::Unit::TestCase
  include BackupCheckSupport

  def setup
    makef(ROOT,[{'d1' => ['d1f1', 'd1f2', 'd1f3']},
                'f4','h1.txt',
                ['f5', 'f6', 'f7'],
                {'d2' => ['d2f1', 'd2f2']}])
    @good_config = <<-CONFIG
      check:
        default_check:
          base_path: #{ROOT}
        f4:
          files: f4
        d1:
          files: [d1, d1/d1f1]
          recursive_order: mtime
      #  wildcard:
      #    files: d1/d1*
    CONFIG
  end

  def teardown
    rm_rf ROOT
  end

  def test_simple
    m = Main.new([])
    out = m.run_config(@good_config)
    assert(/No failed checks/.match(out))
  end

  def test_sample_config
    fname = ROOT + '/sample.yaml'
    m1 = Main.new(['-s',fname])
    m1.run_reckoner
    assert File.exist?(fname)

    m2 = Main.new(['-e',fname])
    out = m2.run_reckoner
    assert(/Reckoner found a problem with '\/etc\/fake-file'/.match(out))
  end

  def test_additional_checks
    m1 = Main.new(['-c','test/files/additional_checks.rb'])
    out = m1.run_config <<-CONFIG
      check:
        default_check:
          base_path: #{ROOT}
        txt:
          files: [d1, h1.txt]
          extension: .txt
     CONFIG
    assert_equal 2,out.split("\n").length
    assert(/Extension found a problem with '\/tmp\/file_verifier_tests\/d1'/.match(out))
  end
end
