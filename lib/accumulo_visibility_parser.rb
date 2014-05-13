require "accumulo_visibility_parser/version"
require 'parslet'
require 'parslet/convenience'

module AccumuloVisibilityParser
  class VisiblityParser < Parslet::Parser
    #tokens
    rule(:vis_str) { match['a-zA-Z0-9_-'].repeat(1) }
    rule(:pipe) { str("|") }
    rule(:ampersand) { str("&") }
    rule(:left_paren) { str("(") }
    rule(:right_paren) { str(")") }
    rule(:no_right_paren) { right_paren.absent? }

    # top level groups, hope to apply logic in tranform
    rule(:vis) { vis_str | (left_paren >> vis_str >> right_paren) }
    rule(:or_expr_group) {
      (vis >> (pipe >> vis).repeat(1) >> no_right_paren) |
      (left_paren >> vis >> (pipe >> vis).repeat(1) >> right_paren )
    }
    rule(:and_expr_group) {
      (vis >> (ampersand >> vis).repeat(1) >> no_right_paren) |
      (left_paren >> vis >> (ampersand >> vis).repeat(1) >> right_paren)
    }
    rule(:expr) { or_expr_group | and_expr_group | vis }
    rule(:or_expr) { expr >> (pipe >> expr).repeat(1) }
    rule(:and_expr) { expr >> (ampersand >> expr).repeat(1) }

    # root
    rule(:expression) { or_expr | and_expr | expr }
    root(:expression)
  end

  def self.parse visibility_string
    VisiblityParser.new.parse_with_debug(visibility_string)
    #VisiblityParser.new.parse(visibility_string)
  end
end
