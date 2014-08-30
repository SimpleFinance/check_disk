#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'
require 'check_disk/blocks'
require 'check_disk/inodes'

module CheckDisk
  # A Sensu Plugin to check disk block and inode usage by mountpoint.
  # Takes a mount point in as `path`.
  # Takes warning, and critical parameters that set a percentage [0-100].
  # Takes parameters to check either file serial numbers (inodes) _or_ blocks.
  # Determines `total number` of inodes|blocks.
  # Determines baseline `percent` based on `total number`.
  # Determines usage by subtracting `available` from `total number`
  # Compares usage to see if greater than baseline.
  #
  # See: statvfs(3)
  # See: https://github.com/djberg96/sys-filesystem
  #
  # "Because parsing the output of `df` is a bad idea."
  class CLI < Sensu::Plugin::Check::CLI
    def initialize
      super
    end

    # Sensu check run loop.
    def run
      blocks if config[:blocks]
      inodes if config[:inodes]
      check_blocks_and_inodes
    end

    private

    def blocks
      check_blocks
      ok
    end

    def inodes
      check_inodes
      ok
    end

    def check_blocks_and_inodes
      check_blocks
      check_inodes
      ok 'block and inode usage lower than warning parameter.'
    end

    def check_blocks
      disk = CheckDisk::Block.new(config)
      common_check(disk)
    end

    def check_inodes
      disk = CheckDisk::Inode.new(config)
      common_check(disk)
    end

    def common_check(disk)
      message(disk.message)
      warning if disk.warning?
      critical if disk.critical?
    end

    # Adds a `-p` or `--path` option to our CLI.
    # Sets `config[:path]`
    # @return [String] The `path` or `mount point` we are checking.
    option(
      :path,
      short: '-p PATH',
      default: '/',
      description: 'The `path` or `mount point` we are checking. eg; /mnt'
    )

    # Adds a `--inodes` option to our CLI.
    # Sets `config[:inodes]`
    # @return [TrueClass, FalseClass] Boolean for enabling inode code path.
    option(
      :inodes,
      short: '-i',
      boolean: true,
      description: 'Boolean for enabling inode code path.'
    )

    # Adds a `--blocks` option to our CLI.
    # Sets `config[:blocks]`
    # @return [TrueClass, FalseClass] Boolean for enabling block code path.
    option(
      :blocks,
      short: '-b',
      boolean: true,
      description: 'Boolean for enabling block code path.'
    )

    # Adds a `-w` or `--warning` option to our CLI.
    # Sets `config[:warning]`
    # @return [Fixnum] The high water mark for `warning` alerts.
    option(
      :warning,
      short: '-w PERCENT',
      proc: proc { |a| a.to_i },
      default: 50,
      description: 'The high water mark for `warning` alerts. eg; 50'
    )

    # Adds a `-c` or `--critical` option to our CLI.
    # Sets `config[:critical]`
    # @return [Fixnum] The high water mark for `critical` alerts.
    option(
      :critical,
      short: '-c PERCENT',
      proc: proc { |a| a.to_i },
      default: 75,
      description: 'The high water mark for `critical` alerts. eg; 75'
    )
  end
end
