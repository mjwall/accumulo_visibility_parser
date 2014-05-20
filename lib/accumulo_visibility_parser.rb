require "accumulo_visibility_parser/version"
require 'parslet'
require 'parslet/convenience'

module AccumuloVisibilityParser
  class VisiblityParser < Parslet::Parser
    #tokens
    rule(:vis_token) { match['a-zA-Z0-9_-'].repeat(1).as(:vis) }
    rule(:vis) { lparen >> vis_token >> rparen | vis_token }
    rule(:pipe) { str("|") }
    rule(:amp) { str("&") }
    rule(:lparen) { str("(") }
    rule(:rparen) { str(")") }

    #grammar
    rule(:expression) {
      lparen >> body >> rparen
    }

    rule(:body) {
      and_expr |
      or_expr |
      expression |
      vis
    }

    rule(:or_term) {
      and_block | vis
    }

    rule(:or_block) {
      lparen >> or_expr >> rparen
    }

    rule(:or_expr) {
      (or_term >> (pipe >> (or_block | or_term)).repeat(1)).as(:or_expr)
    }

    rule(:and_term) {
      or_block | vis
    }

    rule(:and_block) {
      lparen >> and_expr >> rparen
    }

    rule(:and_expr) {
     (and_term >> (amp >> (and_block | and_term)).repeat(1)).as(:and_expr)
    }

    # root
    root :expression
  end

  class VisibilityTransform < Parslet::Transform
    rule(:and_expr => subtree(:and_expr)) {{ :and => and_expr }}
    rule(:or_expr => subtree(:or_expr))  {{ :or => or_expr }}
    rule(:vis => simple(:vis)) { vis.str }
  end

  # returns a hash representing the expression
  def self.parse visibility_string
    # always append outer parens to make it consistent
    VisibilityTransform.new.apply(VisiblityParser.new.parse("(#{visibility_string})"))
  end

  private
  # just a helper to spit out debug info, only used in tests, don't use for real
  def self.parse_debug visibility_string
    VisiblityParser.new.parse_with_debug("(#{visibility_string})")
  end
end
