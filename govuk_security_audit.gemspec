# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'govuk_security_audit/version'

Gem::Specification.new do |spec|
  spec.name          = "govuk_security_audit"
  spec.version       = GovukSecurityAudit::VERSION
  spec.authors       = ["Government Digital Service"]
  spec.email         = ["govuk-dev@digital.cabinet-office.gov.uk"]

  spec.summary       = %q{Check repos for gem vulnerabilities}
  spec.description   = %q{Wraps bundler-audit gem to check specific repos for gem vulnerabilities}
  spec.homepage      = "https://github.com/alphagov/govuk_security_audit"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "gem_publisher", "1.5.0"
end
