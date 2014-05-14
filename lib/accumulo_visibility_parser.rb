require "accumulo_visibility_parser/version"
require 'parslet'
require 'parslet/convenience'

module AccumuloVisibilityParser
  class VisiblityParser < Parslet::Parser
    #tokens
    rule(:vis) { match['a-zA-Z0-9_-'].repeat(1) }
    rule(:pipe) { str("|") }
    rule(:amp) { str("&") }
    rule(:lparen) { str("(") }
    rule(:rparen) { str(")") }

    rule(:single_expr) {
      lparen >> vis >> rparen |
      vis
    }

    rule(:or_expr_no_paren) {
      single_expr >> (pipe >> single_expr).repeat(1)
    }

    rule(:or_expr_paren) {
      lparen >> or_expr_no_paren >> rparen
    }

    rule(:or_expr) {
      or_expr_no_paren | or_expr_paren
    }

    rule(:and_expr_no_paren) {
      single_expr >> (amp >> single_expr).repeat(1)
    }

    rule(:and_expr_paren) {
      lparen >> and_expr_no_paren >> rparen
    }

    rule(:and_expr) {
      and_expr_paren | and_expr_no_paren
    }

    rule(:expr) {
      or_expr | and_expr | single_expr
    }

    rule(:nested_and) {
      #expr >> amp >> or_expr_paren >> expr |
      expr >> amp >> or_expr_paren #|
      #or_expr_paren >> amp >> expr
    }

    rule(:nested_or) {
      #expr >> pipe >> and_expr_paren >> expr |
      expr >> pipe >> and_expr_paren  #|
      #and_expr_paren >> pipe >> expr
    }

    rule(:top_level) {
      nested_or |
      nested_and |
      expr
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
