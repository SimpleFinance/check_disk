require 'check_disk/template'

module CheckDisk
  # Interface for checking Inodes.
  class Inode < CheckDisk::Template
    def initialize(config)
      super
    end

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

    def warning?
      percent_of_inodes_used > warning
    end

    def critical?
      percent_of_inodes_used > critical
    end

    def message
      "#{ percent_of_inodes_used }% of inodes used. " \
      "path: #{ path } total: #{ total } available: #{ available }"
    end

    private

    # @return [Fixnum] total number of file serial numbers (inodes).
    def inodes_total
      path_stat.files
    end

    # @return [Fixnum] number of available file serial numbers (inodes).
    def inodes_available
      path_stat.files_available
    end

    # @return [Fixnum] total number of inodes used.
    def inodes_used
      inodes_total - inodes_available
    end

    # @return [Fixnum] computed inodes used by percent.
    def percent_of_inodes_used
      percent_of(inodes_total, inodes_used)
    end
  end
end
