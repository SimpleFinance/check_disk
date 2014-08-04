#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'
require 'sys/filesystem'

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

    include Sys

    # Sensu check run loop.
    def run
      ok 'Not Implemented'
    end

    private

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
      boolean: true,
      description: 'Boolean for enabling inode code path.'
    )

    # Adds a `--blocks` option to our CLI.
    # Sets `config[:blocks]`
    # @return [TrueClass, FalseClass] Boolean for enabling block code path.
    option(
      :blocks,
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
      default: 85,
      description: 'The high water mark for `warning` alerts. eg; 50'
    )

    # Adds a `-c` or `--critical` option to our CLI.
    # Sets `config[:critical]`
    # @return [Fixnum] The high water mark for `critical` alerts.
    option(
      :critical,
      short: '-c PERCENT',
      proc: proc { |a| a.to_i },
      default: 95,
      description: 'The high water mark for `critical` alerts. eg; 75'
    )
  end
end
