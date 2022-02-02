Gem::Specification.new do |s|
    s.name = %q{simple-annotations}
    s.author = "Romain GEORGES"
    s.version = "0.9.0"
    s.date = "2021-12-27"
    s.summary = "Simple method annotations like in java or Python methods decorators"
    s.email = "romain@ultragreen.net"
    s.homepage = "http://www.ultragreen.net"
    s.description = "Simple method annotations like in java or Python methods decorators"
    s.files = `git ls-files`.split($/)
    s.required_ruby_version = '~> 2.7.0'
    s.add_development_dependency "rspec", "~> 3.10"
    s.add_development_dependency "roodi", "~> 5.0"
    s.add_development_dependency "rake", "~> 12.3"
    s.add_development_dependency "yard", "~> 0.9"
    s.add_development_dependency "yard-rspec", "~> 0.1"
    s.require_paths = ["lib"]
    s.require_paths << 'bin'
    s.bindir = 'bin'
    s.executables = Dir["bin/*"].map!{|item| item.gsub("bin/","")}
    s.test_files    = s.files.grep(%r{^(test|spec|features)/})
    s.license = "BSD-2-Clause"
  end
  