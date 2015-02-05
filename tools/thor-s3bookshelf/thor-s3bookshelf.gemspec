# coding: utf-8
require_relative './lib/thor/s3bookshelf/version'

Gem::Specification.new do |spec|
  spec.name          = 'thor-s3bookshelf'
  spec.version       = Thor::S3Bookshelf::VERSION
  spec.authors       = ['John Manero']
  spec.email         = ['john.manero@gmail.com']
  spec.summary       = 'Upload cookbooks to S3'
  spec.description   = IO.read(File.expand_path('../README.md', __FILE__)) rescue 'Unable to read README.md'
  spec.homepage      = 'https://github.com/jmanero/berks-s3'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_runtime_dependency 'aws-sdk'
  spec.add_runtime_dependency 'buff-ignore'
  spec.add_runtime_dependency 'chef'
  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'thor-scmversion'
end
