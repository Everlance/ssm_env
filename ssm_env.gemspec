# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ssm_env/version'

Gem::Specification.new do |spec|
  spec.name          = "ssm_env"
  spec.version       = SsmEnv::VERSION
  spec.authors       = ["Rob Lane"]
  spec.email         = ["rob@everlance.com"]
  spec.license       = 'MIT'

  spec.summary       = "Synchronize your AWS SSM parameters to your environment"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables << 'ssm_env'
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "aws-sdk-ssm", "~> 1.41.0"
  spec.add_runtime_dependency "thor", "~> 1.1"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
