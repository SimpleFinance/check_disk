check_disk
==========

 * A sensu check for disks.
 * A Sensu Plugin to check disk block and inode usage by mountpoint.
 * Takes a mount point in as `path`.
 * Takes warning, and critical parameters that set a percentage [0-100].
 * Takes parameters to check either file serial numbers (inodes) _or_ blocks.
 * Determines `total number` of inodes|blocks.
 * Determines baseline `percent` based on `total number`.
 * Determines usage by subtracting `available` from `total number`
 * Compares usage to see if greater than baseline.

See: statvfs(3)
See: [https://github.com/djberg96/sys-filesystem](https://github.com/djberg96/sys-filesystem)

"Because parsing the output of `df` is a bad idea."

# Install

This project is laid out as a Ruby Gem.

You can add this repository to your Gemfile, or create a gem and install that.

# Use

```
check_disk.rb -h
Usage: check_disk.rb (options)
    -b                               Boolean for enabling block code path.
    -c PERCENT                       The high water mark for `critical` alerts. eg; 75
    -i                               Boolean for enabling inode code path.
    -p PATH                          The `path` or `mount point` we are checking. eg; /mnt
    -w PERCENT                       The high water mark for `warning` alerts. eg; 50
```

```
$ check_disk.rb -i
CheckDisk::CLI WARNING: 65% of inodes used. path: / total: 121846308 available: 42055237
```

# Build

`gem build check_disk.gemspec`

# Test

`make test`

or

`bundle exec rake test:all`

## Coverage

View test coverage executing `make test` then opening `coverage/index.html`
