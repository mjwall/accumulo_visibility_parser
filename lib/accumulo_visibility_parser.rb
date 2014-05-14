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

    rule(:top_level) {
      #(expr >> ampersand >> expr) |
      #(expr >> pipe >> expr) |
      expr
    }

    rule(:expr) {
      or_expr | and_expr | single
    }

    rule(:or_expr) {
      or_expr_with_paren | or_expr_no_paren
    }

    rule(:or_expr_no_paren) {
      vis >> (pipe >> (single | or_expr | and_expr_with_paren)).repeat(1)
    }

    rule(:or_expr_with_paren) {
      left_paren >> or_expr_no_paren >> right_paren
    }

    rule(:and_expr) {
      and_expr_with_paren | and_expr_no_paren
    }

    rule(:and_expr_no_paren) {
      vis >> (ampersand >> (single | and_expr | or_expr_with_paren)).repeat(1)
    }

    rule(:and_expr_with_paren) {
      (left_paren >> and_expr_no_paren >> right_paren)
    }

    rule(:single) {
      (left_paren >> vis >> right_paren) |
      vis
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
