require_relative 'spec_helper'
require_relative '../../bin/check_disk'

describe CheckDisk, '' do
  let(:check) { CheckDisk.new }

  before :each do
    @check = check
  end

  describe 'Object Ancestry Checks' do
    it 'Is a ChefInstance::Install::Template?' do
      @check.must_be_kind_of(Sensu::Plugin::Check::CLI)
    end
  end
end
