require 'sys/filesystem'

module CheckDisk
  # Interface for checking Inodes.
  class Inode
    def initialize(config)
      @config = config
    end

    include Sys

    # @return [Sys::Filesystem::Stat] a data structure about our filesystem.
    def path_stat
      @fs ||= Filesystem.stat(path)
    end

    # @return [Fixnum] number of available file serial numbers (inodes).
    def inodes_available
      path_stat.files_free
    end

    # @return [Fixnum] total number of file serial numbers (inodes).
    def inodes_total
      path_stat.files
    end

    # @return [Fixnum] total number of inodes used.
    def inodes_used
      inodes_total - inodes_available
    end

    # @param percent [Fixnum] the percentage to check.
    # @return [Fixnum] computed inodes used by percent.
    def percent_of_inodes_used
      percent_of(inodes_total, inodes_used)
    end

    private

    # @return [Fixnum] The warning passed in.
    def warning
      config[:warning]
    end

    # @return [Fixnum] The critical passed in.
    def critical
      config[:critical]
    end
  end
end
