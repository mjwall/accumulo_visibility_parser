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

    #grammar, assumes entire thing wrapped in parens
    rule(:expression) {
      lparen >> body >> rparen
    }

    rule(:body) {
      and_expr |
      or_expr |
      expression |
      vis
    }

    rule(:or_expr) {
      lparen >> left_or >> pipe >> right_or >> rparen |
      left_or >> pipe >> right_or
    }

    rule(:left_or) {
      lparen >> vis >> pipe >> or_expr >> rparen |
      lparen >> and_expr >> rparen |
      vis >> pipe >> or_expr |
      lparen >> vis >> rparen |
      vis
    }

    rule(:right_or) {
      lparen >> or_expr >> pipe >> vis >> rparen |
      lparen >> and_expr >> rparen |
      or_expr >> pipe >> vis |
      lparen >> vis >> rparen |
      vis
    }

    rule(:and_expr) {
      lparen >> left_and >> amp >> right_and >> rparen |
      left_and >> amp >> right_and
    }

    rule(:left_and) {
      lparen >> vis >> amp >> and_expr >> rparen |
      lparen >> or_expr >> rparen |
      vis >> amp >> and_expr |
      lparen >> vis >> rparen |
      vis
    }

    rule(:right_and) {
      lparen >> and_expr >> amp >> vis >> rparen |
      lparen >> or_expr >> rparen |
      and_expr >> amp >> vis |
      lparen >> vis >> rparen |
      vis
    }

    # root
    root :expression
  end

  def self.parse visibility_string
    # always append parens
    VisiblityParser.new.parse("(#{visibility_string})")
  end

  def self.parse_debug visibility_string
    VisiblityParser.new.parse_with_debug("(#{visibility_string})")
  end
end
