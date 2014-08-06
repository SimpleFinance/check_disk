require 'check_disk/template'

module CheckDisk
  # Interface for checking Inodes.
  class Block < CheckDisk::Template
    def initialize(config)
      super
    end

    def total
      blocks_total
    end

    def available
      blocks_available
    end

    def used
      blocks_used
    end

    def percent_used
      percent_of_blocks_used
    end

    # Boolean method for determining if we are 'warning?'
    # @return [TrueClass, FalseClass] Warning True or False?
    def warning?
      percent_of_blocks_used > warning
    end

    # Boolean method for determining if we are 'critical?'
    # @return [TrueClass, FalseClass] Critical True or False?
    def critical?
      percent_of_blocks_used > critical
    end

    def message
      "#{ percent_of_blocks_used }% of blocks used. " \
      "total: #{ total } available: #{ available }"
    end

    private

    # @return [Fixnum] number of available blocks.
    def blocks_available
      path_stat.blocks_available
    end

    # @return [Fixnum] total number of blocks.
    def blocks_total
      path_stat.blocks
    end

    # @return [Fixnum] total number of blocks used.
    def blocks_used
      blocks_total - blocks_available
    end

    # @param percent [Fixnum] the percentage to check.
    # @return [Fixnum] computed blocks used by percent.
    def percent_of_blocks_used
      percent_of(blocks_total, blocks_used)
    end
  end
end
