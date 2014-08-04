#!/usr/bin/env ruby

require 'rake'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'bundler'

Bundler.setup

task default: 'test:all'

namespace :test do
  Rake::TestTask.new do |t|
    t.name = :minitest
    t.test_files = Dir.glob('test/**/**/*_{spec,unit}.rb')
  end

  desc 'Run RuboCop on the lib directory'
  RuboCop::RakeTask.new do |t|
    t.name = :rubocop
    t.patterns = [
      'lib/**/*.rb',
      'test/**/*.rb',
      'bin/check_disk.rb',
      'Rakefile',
      'Gemfile'
    ]
    t.fail_on_error = false
  end

  desc 'Run all of the tests.'
  task :all do
    Rake::Task['test:rubocop'].invoke
    Rake::Task['test:minitest'].invoke
  end
end
