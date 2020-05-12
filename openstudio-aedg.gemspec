# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'openstudio/aedg_measures/version'

Gem::Specification.new do |spec|
  spec.name          = 'openstudio-aedg'
  spec.version       = OpenStudio::AedgMeasures::VERSION
  spec.authors       = ['David Goldwasser', 'Nicholas Long']
  spec.email         = ['david.goldwasser@nrel.gov', 'nicholas.long@nrel.gov']

  spec.summary       = 'Library and measures for OpenStudio AEDG'
  spec.description   = 'Library and measures for OpenStudio AEDG'
  spec.homepage      = 'https://openstudio.net'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|lib.measures.*tests|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.5.0'

  spec.add_dependency 'bundler', '~> 2.1'

  spec.add_development_dependency 'github_api', '~> 0.18.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'rubocop', '~> 0.54.0'

  spec.add_dependency 'openstudio-extension', '~> 0.2.1'
  spec.add_dependency 'openstudio-standards', '~> 0.2.11'
end
