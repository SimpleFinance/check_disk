require 'sys/filesystem'

module CheckDisk
  # Interface for checking Inodes.
  class Template
    def initialize(config)
      @config = config
    end

    include Sys

    private

    # in-line convert to float so we get '0.<some percent>'
    # convert our result back to integer to drop the remainder.
    # @return [Fixnum] percentage of amount
    def percent_of(total, used)
      ((used.to_f / total.to_f) * 100).to_i
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
