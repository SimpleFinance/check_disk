# coding: utf-8
require_relative 'lib/check_disk'

Gem::Specification.new do |spec|
  spec.name          = 'check_disk'
  spec.version       = CheckDisk::VERSION
  spec.authors       = ['Miah Johnson']
  spec.email         = %w(miah@simple.com)
  spec.description   = 'Sensu CLI Command Check for disk inode and block ' \
                       ' usage written as a library.'
  spec.summary       = 'Sensu CLI Command Check for disk inode and block usage.'
  spec.homepage      = 'https://github.com/SimpleFinance/sensu_check_disk'
  spec.license       = 'Apache-2.0'
  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)/)
  spec.require_paths = %w(lib)

  spec.add_runtime_dependency 'sensu-plugin', '~> 0.3', '>= 0.3.0'
  spec.add_runtime_dependency 'sys-filesystem', '~> 1.1', '>= 1.1.2'
  spec.add_development_dependency 'minitest', '~> 5.3', '>= 5.3.1'
  spec.add_development_dependency 'rake', '~> 10.3', '>= 10.3.0'
  spec.add_development_dependency 'rubocop', '~> 0.20', '>= 0.20.1'
  spec.add_development_dependency 'simplecov', '~> 0.8', '>= 0.8.2'
end