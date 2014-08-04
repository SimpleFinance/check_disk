require 'sys/filesystem'

module CheckDisk
  # Interface for checking Inodes.
  class Inode
    def initialize(config)
      @config = config
    end

    include Sys

    def total
      inodes_total
    end

    def available
      inodes_available
    end

    def used
      inodes_used
    end

    def percent_used
      percent_of_inodes_used
    end

    private

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

    # @return [Fixnum] percentage of amount
    def percent_of(amount, percent)
      amount / 100 * percent
    end

    # @return [Sys::Filesystem::Stat] a data structure about our filesystem.
    def path_stat
      @fs ||= Filesystem.stat(path)
    end

    # @return [String] The path passed in (or its default).
    def path
      config[:path]
    end

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