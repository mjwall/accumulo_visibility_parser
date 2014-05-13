require "accumulo_visibility_parser/version"
require 'parslet'
require 'parslet/convenience'

module AccumuloVisibilityParser
  class VisiblityParser < Parslet::Parser
    #tokens
    rule(:vis) { match['a-zA-Z0-9_-'].repeat(1) }
    rule(:pipe) { str("|") }
    rule(:ampersand) { str("&") }
    rule(:left_paren) { str("(") }
    rule(:right_paren) { str(")") }
    rule(:no_right_paren) { right_paren.absent? }

    rule(:top_level) {
      expr >> pipe >> expr |
      expr >> ampersand >> expr |
      expr >> pipe >> single |
      single >> pipe >> expr |
      expr >> ampersand >> single |
      single >> ampersand >> expr |
      expr |
      single
    }

    rule(:or_expr) {
      (left_paren >> vis >> (pipe >> (single | or_expr | (left_paren >> and_expr >> right_paren))).repeat(1) >> right_paren) |
      (vis >> (pipe >> (single | or_expr | (left_paren >> and_expr >> right_paren))).repeat(1))
    }

    rule(:and_expr) {
      (left_paren >> vis >> (ampersand >> (single | and_expr | (left_paren >> or_expr >> right_paren))).repeat(1) >> right_paren) |
      (vis >> (ampersand >> (single | and_expr | (left_paren >> or_expr >> right_paren))).repeat(1))
    }

    rule(:single) {
      (left_paren >> vis >> right_paren) |
      vis
    }

    rule(:expr) {
      and_expr | or_expr
    }

    # root
    root :top_level
  end

  def self.parse visibility_string
    VisiblityParser.new.parse(visibility_string)
  end

  def self.parse_debug visibility_string
    VisiblityParser.new.parse_with_debug(visibility_string)
  end
end
