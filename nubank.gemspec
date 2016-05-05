lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nubank/version'

Gem::Specification.new do |s|
  s.name          = 'nubank-cli'
  s.version       = NubankCli::VERSION
  s.summary       = "Nubank CLI"
  s.description   = "Manage your Nubank account via CLI."
  s.authors       = ["Rodrigo Muniz"]
  s.email         = 'rodrigo.temiski1995@gmail.com'
  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir        = "bin"
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.homepage      = 'http://rubygems.org/gems/nubank-cli'
  s.license       = 'MIT'
  
  # s.add_dependency 'activesupport', '>= 3.2.0'
  # s.add_dependency 'colored'
  s.add_dependency 'curb', "~> 0"
  s.add_dependency 'thor', "~> 0"
  s.add_dependency 'curses'
  s.add_dependency 'odf-report', "~> 0"
  # s.add_dependency 'nokogiri'
  # s.add_dependency 'hashie'
  # s.add_dependency 'faraday'
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "bundler", "~> 1.10"
  s.add_development_dependency 'pry', "~> 0"
end