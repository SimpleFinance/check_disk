require_relative 'sensu_plugin_helper'
require 'English'

# Unit Test for `bin/check_disk`
class TestCheckExternal < MiniTest::Test
  include SensuPluginTestHelper

  def setup
    script 'bin/check_disk.rb'
  end

  # Warning and Critical at 100%, should exit ok.
  def test_ok
    run_script '-p / -w 100 -c 100'
    assert $CHILD_STATUS.exitstatus == 0, 'Did not exit ok.'
  end

  # If the disk is more than 1% used we should exit warning.
  def test_warning
    run_script '-w 1'
    assert $CHILD_STATUS.exitstatus == 1, 'Did not exit warning.'
  end

  # If the disk is more than 1% used we should exit critical.
  def test_critical
    run_script '-c 1'
    assert $CHILD_STATUS.exitstatus == 2, 'Did not exit critical.'
  end

  def test_fallthrough
    run_script
    assert $CHILD_STATUS.exitstatus == 1
  end

  def test_exception
    output = run_script '-f'
    assert $CHILD_STATUS.exitstatus == 2 && output.include?('failed')
  end

  # Do we see the right message when OK?
  def test_argv
    output = run_script '-p / -w 100 -c 100'
    assert $CHILD_STATUS.exitstatus == 0 && output.include?('threshold')
  end

  def test_bad_commandline
    output = run_script '--doesnotexist'
    assert $CHILD_STATUS.exitstatus == 2 &&
      output.include?('doesnotexist') &&
      output.include?('invalid option')
  end
end
