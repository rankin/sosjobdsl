# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sosjobdsl/version'

Gem::Specification.new do |spec|
  spec.name          = "sosjobdsl"
  spec.version       = Sosjobdsl::VERSION
  spec.authors       = ["Christopher Rankin"]
  spec.email         = ["crankin@amdirent.com"]

  spec.summary       = %q{DSL to create jobs for JobScheduler.}
  spec.description   = %q{Utilizing the power of ruby to create a DSL to create jobs for the JobScheduler}
  spec.homepage      = "https://amdirent.com"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "nokogiri", "~> 1.6.6.2"
end
