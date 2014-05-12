require "accumulo_visibility_parser/version"
require 'parslet'

module AccumuloVisibilityParser
  class VisiblityParser < Parslet::Parser
    rule(:vis) { match('[a-zA-Z0-9_-]').repeat(1) }
    rule(:pipe) { match("[|]") }
    rule(:ampersand) { match("[&]")}
    rule(:or_expr) { vis >> (pipe >> vis).repeat(1) }
    rule(:and_expr) { vis >> (ampersand >> vis).repeat(1) }
    rule(:expression) { vis | or_expr | and_expr }
    root(:expression)
  end

  def self.parse visibility_string
    VisiblityParser.new.parse(visibility_string)
  end
end
