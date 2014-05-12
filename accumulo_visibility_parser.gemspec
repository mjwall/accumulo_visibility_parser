# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'accumulo_visibility_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "accumulo_visibility_parser"
  spec.version       = AccumuloVisibilityParser::VERSION
  spec.authors       = ["Michael Wall"]
  spec.email         = ["mjwall@gmail.com"]
  spec.description   = %q{Ruby library to parse Accumulo Visibility strings}
  spec.summary       = %q{See https://github.com/apache/accumulo/blob/master/core/src/main/java/org/apache/accumulo/core/security/ColumnVisibility.java#L404 for info about what these string can be }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "parslet", "1.5.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "minitest", "4.7.5"
  spec.add_development_dependency "guard", "2.2.4"
  spec.add_development_dependency "guard-minitest", "1.3.1"
  spec.add_development_dependency "mocha", "0.14.0"
  spec.add_development_dependency "rake", "10.3.1"
end
