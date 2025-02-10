lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/plural_converter/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-plural_converter'
  spec.version       = Fastlane::PluralConverter::VERSION
  spec.author        = 'Benoit Deldicque'
  spec.email         = 'bixcorp@gmail.com'

  spec.summary       = 'Convert Android plural XML resource file to iOS stringsdict file.'
  spec.homepage      = "https://github.com/bixcorp/fastlane-plugin-plural_converter"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.6'

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  # spec.add_dependency 'your-dependency', '~> 1.0.0'
end
