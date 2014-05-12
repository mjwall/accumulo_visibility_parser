ENV['RACK_ENV']="test"
require 'rubygems' if !defined?(Gem)
require 'bundler/setup'
Bundler.setup(:default, :test)
$LOAD_PATH.unshift File.expand_path("../lib",__FILE__)

require File.expand_path '../../lib/accumulo_visibility_parser.rb', __FILE__
require 'minitest/autorun'

#require 'minitest/reporters'

class AccumuloVisibilitySpec < MiniTest::Spec

end

require 'mocha/setup'
