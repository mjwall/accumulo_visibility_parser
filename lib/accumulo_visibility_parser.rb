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
    rule(:operator) { pipe | ampersand }

    # top level groups, hope to apply logic in tranform
    rule(:vis) { vis_str }
    rule(:simple_or) { vis >> (pipe >> vis).repeat(1) >> ampersand.absent? }
    rule(:simple_and) {vis >> (ampersand >> vis).repeat(1) >> pipe.absent? }
    rule(:one_level_expr) {
      left_paren >> (simple_or | simple_and | vis) >> right_paren
    }
    rule(:one_level_expr_no_paren) {
      simple_or | simple_and | vis
    }
    rule(:two_level_expr) {
      (one_level_expr_no_paren >> operator >> one_level_expr ) |
      (one_level_expr >> operator >> one_level_expr_no_paren) |
      (one_level_expr >> operator >> one_level_expr)
    }
    rule(:multi_level_expr) {
      (two_level_expr >> operator >> one_level_expr_no_paren) |
      (two_level_expr >> (operator >> one_level_expr).repeat(1))
    }

    # root
    rule(:expression) { multi_level_expr | two_level_expr | one_level_expr | simple_and | simple_or | vis }
    root(:expression)
  end

  def self.parse visibility_string
    #begin
      VisiblityParser.new.parse(visibility_string)
    #rescue Parslet::ParseFailed => e
    #  puts e.cause.ascii_tree
    #end
  end

  def self.parse_debug visibility_string
    VisiblityParser.new.parse_with_debug(visibility_string)
  end
end
