require_relative '../../spec_helper'
require 'check_disk/inodes'
require 'ostruct'

describe CheckDisk::Inode, '' do
  let(:check) { CheckDisk::Inode.new(config) }

  # Sensu CLI would send our program a hash of configuration options.
  # @return [Hash] our mock 'config'
  let(:config) do
    {
      path: '/',
      warning: 50,
      critical: 75
    }
  end

  # @return [OpenStruct] a mock object containing some of the output of a
  # Sys::Filesystem::Stat
  let(:filesystem) do
    OpenStruct.new(
      files: 121_846_308,
      files_available: 42_461_553
    )
  end

  describe 'Object Ancestry Checks' do
    it 'Is a Sensu CLI Check Plugin?' do
      check.must_be_kind_of(CheckDisk::Inode)
    end
  end

  # This test should be moved to a unit test.
  # It tests a method provided by the template
  # It modifies class internals to test.
  describe 'Discovers filesystem details.' do
    it 'Can discover the filesystem.' do
      module CheckDisk
        # Adds a public method to gain access to a private method for testing.
        class Inode
          def filesystem_details
            path_stat
          end
        end
      end

      check.must_respond_to(:filesystem_details)
      check.filesystem_details.must_be_instance_of(Sys::Filesystem::Stat)
    end
    it 'Can find total number of inodes.' do
      check.must_respond_to(:total)
      check.stub :path_stat, (filesystem) do
        check.total.must_equal(121_846_308)
      end
    end

    it 'Can find inodes available.' do
      check.must_respond_to(:available)
      check.stub :path_stat, (filesystem) do
        check.available.must_equal(42_461_553)
      end
    end

    it 'Can find inodes used.' do
      check.must_respond_to(:used)
      check.stub :path_stat, (filesystem) do
        check.used.must_equal(79_384_755)
      end
    end

    it 'Can find percent of inodes used.' do
      check.must_respond_to(:percent_used)
      check.stub :path_stat, (filesystem) do
        check.percent_used.must_equal(65)
      end
    end

    it 'Can tell us if we are warning?' do
      check.must_respond_to(:warning?)
      check.stub :path_stat, (filesystem) do
        check.warning?.must_equal(true)
      end
    end

    it 'Can tell us if we are critical?' do
      check.must_respond_to(:warning?)
      check.stub :path_stat, (filesystem) do
        check.critical?.must_equal(false)
      end
    end
  end
end
