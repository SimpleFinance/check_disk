require_relative '../../spec_helper'
require_relative '../../../../lib/check_disk/inodes'
require 'ostruct'

describe CheckDisk, '' do
  let(:check) { CheckDisk::Inode.new(config) }
  let(:config) do
    {
      path: '/',
      warning: 50,
      critical: 75
    }
  end
  let(:filesystem) do
    OpenStruct.new(
      files: 121_846_308,
      files_available: 42_461_553
    )
  end

  before :each do
    @check = check
  end

  describe 'Object Ancestry Checks' do
    it 'Is a Sensu CLI Check Plugin?' do
      @check.must_be_kind_of(CheckDisk::Inode)
    end
  end

  describe 'Discovers filesystem details.' do
    it 'Can find total number of inodes.' do
      @check.must_respond_to(:total)
      @check.stub :path_stat, (filesystem) do
        @check.total.must_equal(121_846_308)
      end
    end

    it 'Can find inodes available.' do
      @check.must_respond_to(:available)
      @check.stub :path_stat, (filesystem) do
        @check.available.must_equal(42_461_553)
      end
    end

    it 'Can find inodes used.' do
      @check.must_respond_to(:used)
      @check.stub :path_stat, (filesystem) do
        @check.used.must_equal(79_384_755)
      end
    end

    it 'Can find percent of inodes used.' do
      @check.must_respond_to(:percent_used)
      @check.stub :path_stat, (filesystem) do
        @check.percent_used.must_equal(55)
      end
    end
  end
end
