# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exoscale/version'

Gem::Specification.new do |spec|
  spec.name          = "exoscale"
  spec.version       = Exoscale::VERSION
  spec.authors       = ["Nicolas Brechet"]
  spec.email         = ["nicolasbrechet@me.com"]

  spec.summary       = %q{Use Exoscale services through Ruby}
  spec.description   = %q{Simple Ruby gem to access Exoscale API}
  spec.homepage      = "https://github.com/nicolasbrechet/ruby-exoscale"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '~> 2.1'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'minitest'
  
end
