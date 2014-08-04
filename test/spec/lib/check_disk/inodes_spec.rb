require_relative '../../spec_helper'
require_relative '../../../../lib/check_disk/inodes'

describe CheckDisk, '' do
  let(:check) { CheckDisk::Inode.new }

  before :each do
    @check = check
  end

  describe 'Object Ancestry Checks' do
    it 'Is a Sensu CLI Check Plugin?' do
      @check.must_be_kind_of(CheckDisk::Inode)
    end
  end
end
