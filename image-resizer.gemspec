lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'image_resizer/version'

Gem::Specification.new do |spec|
  spec.name          = 'image-resizer'
  spec.version       = ImageResizer::VERSION
  spec.authors       = ['Paolo Zaccagnini']
  spec.email         = ['paolo.zaccagnini@lonelyplanet.com']
  spec.summary       = 'Resrc.it wrapper'
  spec.description   = 'Convenient resrc.it API wrapper'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '3.1.0'
end
