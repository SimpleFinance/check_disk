require 'sys/filesystem'

module CheckDisk
  # Interface for checking Inodes.
  class Block
    def initialize(config)
      @config = config
    end

    include Sys

    # @return [Fixnum] number of available blocks.
    def blocks_available
      path_stat.blocks_free
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
    def blocks_used_from_percent(percent)
      percent_of(blocks_total, percent)
    end

    private

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
