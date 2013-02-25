# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'link_to_active_state/version'

Gem::Specification.new do |gem|
  gem.name          = "link_to_active_state"
  gem.version       = LinkToActiveState::VERSION
  gem.authors       = ["Robert May"]
  gem.email         = ["robotmay@gmail.com"]
  gem.description   = %q{A simple gem to implement active states on links using the standard Rails `link_to` helper.}
  gem.summary       = %q{Active states for links using the Rails link_to helper.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.cert_chain = [".public_cert.pem"]
  gem.signing_key = ENV['PRIVATE_KEY']

  gem.add_development_dependency "rails", [">= 3.2.11"]
  gem.add_development_dependency "rspec", ["~> 2.13.0"]
end
