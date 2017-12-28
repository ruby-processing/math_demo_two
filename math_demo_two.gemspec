# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rake'

Gem::Specification.new do |spec|
  spec.name = 'math_demo_two'
  spec.version = 1.0
  spec.author = 'monkstone'
  spec.email = 'mamba2928@yahoo.co.uk'
  spec.description = <<-EOS
  Math Demo Two uses propane (a ruby wrapper for the processing art framework)
  EOS
  spec.summary = %q{Example of creating a propane app.}
  spec.homepage = "https://ruby-processing.github.io/propane/"
  spec.post_install_message = %q{Congratulations you've just installed a propane gem.}
  spec.license = 'GPL-3.0'
  spec.files = FileList['bin/**/*', 'lib/**/*'].exclude(/jar/).to_a
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.3'
  spec.add_runtime_dependency 'propane', '~> 2.3'
  spec.platform      = 'java'
  spec.add_development_dependency 'rake', '~> 12'
  spec.add_development_dependency 'minitest', '~> 5.10'
end
