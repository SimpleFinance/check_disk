require_relative 'spec_helper'
require_relative '../../bin/check_disk'

describe CheckDisk, '' do
  let(:check) { CheckDisk::CLI.new }

  before :each do
    @check = check
  end

  describe 'Object Ancestry Checks' do
    it 'Is a Sensu CLI Check Plugin?' do
      @check.must_be_kind_of(Sensu::Plugin::Check::CLI)
    end
  end
end
