# frozen_string_literal: true

require 'English'
Gem::Specification.new do |s|
  s.name = 'simple-annotations'
  s.author = 'Romain GEORGES'
  s.version = `cat VERSION`.chomp
  s.summary = 'Simple method annotations like in java or Python methods decorators'
  s.email = 'romain@ultragreen.net'
  s.homepage = 'https://github.com/lecid/simple-annotations'
  s.description = 'Simple method annotations like in java or Python methods decorators'
  s.required_ruby_version = Gem::Requirement.new('>= 3.2.3')
  s.license = 'BSD-3-Clause'
  s.metadata['rubygems_mfa_required'] = 'true'
  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  s.require_paths = ['lib']
  s.add_development_dependency 'bundle-audit', '~> 0.1.0'
  s.add_development_dependency 'code_statistics', '~> 0.2.13'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rspec-expectations', '~> 3.13.0'
  s.add_development_dependency 'rubocop', '~> 1.32'
  s.add_development_dependency 'yard', '~> 0.9.27'
  s.add_development_dependency 'yard-rspec', '~> 0.1'
  s.add_dependency 'version', '~> 1.1'
  s.add_development_dependency 'cyclonedx-ruby', '~> 1.1'
  s.add_development_dependency 'debride', '~> 1.12'
end
