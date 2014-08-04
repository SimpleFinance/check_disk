unless ENV['TRAVIS']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/.gems/'
    add_filter '/test/'
  end
end

require 'minitest/autorun'

Minitest::Test.parallelize_me!
