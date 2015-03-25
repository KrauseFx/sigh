# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sigh/version'

Gem::Specification.new do |spec|
  spec.name          = "sigh"
  spec.version       = Sigh::VERSION
  spec.authors       = ["Felix Krause"]
  spec.email         = ["sigh@krausefx.com"]
  spec.summary       = %q{Because you would rather spend your time building stuff than fighting provisioning}
  spec.description   = %q{Because you would rather spend your time building stuff than fighting provisioning}
  spec.homepage      = "https://fastlane.tools"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 2.0.0'

  spec.files = Dir["lib/**/*"] + %w{ bin/sigh README.md LICENSE }

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'fastlane_core', '>= 0.3.1' # all shared code and dependencies
  spec.add_dependency 'plist', '~> 3.1.0' # for reading the provisioning profile

  spec.add_dependency 'excon' # HTTP Client
  spec.add_dependency 'plist', '~> 3.1.0' # for reading the Psst Response

  # Development only
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'yard', '~> 0.8.7.4'
  spec.add_development_dependency 'webmock', '~> 1.19.0'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
