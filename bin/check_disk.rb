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
# See statvfs(3)
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

  def path
    config[:path]
  end

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

  # @return [Fixnum] number of available blocks.
  def blocks_available
    path_stat.blocks_free
  end

  # @return [Fixnum] total number of blocks.
  def blocks_total
    path_stat.blocks
  end

  # @return [Fixnum] percentage of amount
  def percent_of(amount, percent)
    amount / 100 * percent
  end

  def check_blocks
    warning if blocks_warning?
    critical if percent_critical?(blocks_total)
  end

  def blocks_warning?
    percent_warn?(blocks_total)
  end

  def check_inodes
    warning if percent_warn?(inodes_total)
    critical if percent_critical?(inodes_total)
  end

  def percent_warn?(amount)
    percent_of(amount, config[:warning])
  end

  def percent_critical?
    percent_of(amount, config[:critical])
  end

  option(
    :path,
    short: '-p PATH',
    description: ''
  )

  option(
    :inodes,
    boolean: true,
    description: ''
  )

  option(
    :blocks,
    boolean: true,
    description: ''
  )

  option(
    :warning,
    short: '-w PERCENT',
    proc: proc { |a| a.to_i },
    default: 85,
    description: ''
  )

  option(
    :critical,
    short: '-c PERCENT',
    proc: proc { |a| a.to_i },
    default: 95,
    description: ''
  )
end
