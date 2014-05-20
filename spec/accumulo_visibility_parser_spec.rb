require File.expand_path '../spec_helper.rb', __FILE__

class AccumuloVisibilityParserSpec < MiniTest::Spec

  # tests derived from javadoc at
  # https://github.com/apache/accumulo/blob/1.5.1/core/src/main/java/org/apache/accumulo/core/security/ColumnVisibility.java#L418
  it "should parse A" do
    assert_parse "A", "A"
  end

  it "should parse A|B" do
    assert_parse "A|B", {:or => ['A','B']}
  end

  it "should parse (A|B)&(C|D)" do
    assert_parse "(A|B)&(C|D)", {:and => [{:or => ['A','B']}, {:or => ['C','D']}]}
  end

  it "should parse orange|(red&yellow)" do
    assert_parse "orange|(red&yellow)", {:or => ['orange', {:and => ['red', 'yellow']}]}
  end

  it "should NOT parse A|B&C" do
    assert_parse_fail "A|B&C"
  end

  it "should NOT parse A=B" do
    assert_parse_fail "A=B"
  end

  it "should NOT parse A|B|" do
    assert_parse_fail "A|B|"
  end

  it "should NOT parse A&|B" do
    assert_parse_fail "A&|B"
  end

  it "should NOT parse ()" do
    assert_parse_fail "()"
  end

  it "should NOT parse )" do
    assert_parse_fail ")"
  end

  it "should NOT parse dog|!cat" do
    assert_parse_fail "dog|!cat"
  end

  # end of derived test, these are extra

  it "should parse A&B" do
    assert_parse "A&B", {:and => ['A', 'B']}
  end

  it "should parse (A)" do
    assert_parse "(A)", "A"
  end

  it "should parse (A|B)" do
    assert_parse "(A|B)", {:or => ['A','B']}
  end

  it "should parse (A&B)" do
    assert_parse "(A&B)", {:and => ['A', 'B']}
  end

  it "should parse (A&(B))" do
    assert_parse "(A&(B))", {:and => ['A','B']}
  end

  it "should parse A&B&(D|E)&F" do
    assert_parse "A&B&(D|E)&F", {:and => ['A','B', {:or => ['D','E']}, 'F']}
  end

  it "should parse (A&B&(D|E))|F" do
    assert_parse "(A&B&(D|E))|F", {:or => [{:and => ['A','B', {:or => ['D','E']}]}, 'F']}
  end

  it "should parse A&B&C&(D|E|F)&G" do
    assert_parse "A&B&C&(D|E|F)&G", {:and => ['A','B','C',{:or => ['D','E','F']},'G']}
  end

  it "should NOT parse A&B&(D|E)|F" do
    assert_parse_fail "A&B&(D|E)|F"
  end

  it "should parse (A&B)|(A&D&(F|G))|H" do
    assert_parse "(A&B)|(A&D&(F|G))|H", {:or => [
                                                 {:and => ['A','B']},
                                                 {:and => ['A','D',{:or => ['F','G']}]},
                                                 'H'
                                                ]}
  end

  it "should NOT parse (A&B)|(A&D&(F|G))&H" do
    assert_parse_fail "(A&B)|(A&D&(F|G))&H"
  end

  it "should parse A&(B&(F&C))&(D|E)&(G&H)" do
    # unneeded parens
    assert_parse "A&(B&(F&C))&(D|E)&(G&H)", {:and => [
                                                      'A',
                                                      {:and => ['B', {:and => ['F','C']}]},
                                                      {:or => ['D','E']},
                                                      {:and => ['G','H']}
                                                     ]}
  end

  def assert_parse s, tree
    AccumuloVisibilityParser.parse(s).must_equal tree
  end

  def assert_parse_debug s, tree
    puts "Testing #{s}"
    begin
      puts AccumuloVisibilityParser.parse_debug(s)
    rescue Parslet::ParseFailed
    end
    assert_parse s, tree
  end

  def assert_parse_fail s
    begin
      AccumuloVisibilityParser.parse(s)
      fail "Expected #{s} to fail"
    rescue Parslet::ParseFailed
      # do nothing, we should be here
    end
  end

  def assert_parse_fail_debug s
    puts "Testing #{s}"
    begin
      AccumuloVisibilityParser.parse_debug(s)
      fail "Expected parsing to fail"
    rescue Parslet::ParseFailed
      # do nothing, we should be here
    end
  end
end
