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

    rule(:and_expr) {
      vis >> (amp >> vis).repeat(1) |
      vis >> amp >> vis
    }

    rule(:wrapped_and) {
      lparen >> and_expr >> rparen |
      and_expr
    }

    rule(:or_expr) {
      vis >> (pipe >> vis).repeat(1) |
      vis >> pipe >> vis
    }

    rule(:wrapped_or) {
      lparen >> or_expr >> rparen |
      or_expr
    }

    rule(:wrapped_vis) {
      lparen >> vis >> rparen |
      vis
    }

    rule(:expr) {
      wrapped_and | wrapped_or | wrapped_vis
    }

    rule(:top_level_or) {
      expr >> (pipe >> expr).repeat(1)
    }

    rule(:top_level_and) {
      expr >> (amp >> expr).repeat(1)
    }

    rule(:top_level_expr) {
      top_level_or | top_level_and | expr
    }

    rule(:top_level) {
      lparen >> top_level_expr >> rparen |
      top_level_expr
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
