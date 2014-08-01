#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'
require 'sys/filesystem'

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
class CheckDisk < Sensu::Plugin::Check::CLI
  def initialize
    super
  end

  include Sys

  def run
    unknown 'Not Implemented'
  end

  private

  # @return [String] The path passed in (or its default).
  def path
    config[:path]
  end

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
  def inodes_used_from_percent(percent)
    percent_of(inodes_total, percent)
  end

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

  # @return [Fixnum] percentage of amount
  def percent_of(amount, percent)
    amount / 100 * percent
  end

  # Adds a `-p` or `--path` option to our CLI.
  # Sets `config[:path]`
  # @return [String] The `path` or `mount point` we are checking.
  option(
    :path,
    short: '-p PATH',
    description: 'The `path` or `mount point` we are checking.'
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
    description: 'The high water mark for `warning` alerts.'
  )

  # Adds a `-c` or `--critical` option to our CLI.
  # Sets `config[:critical]`
  # @return [Fixnum] The high water mark for `critical` alerts.
  option(
    :critical,
    short: '-c PERCENT',
    proc: proc { |a| a.to_i },
    default: 95,
    description: 'The high water mark for `critical` alerts.'
  )
end
