require File.expand_path '../spec_helper.rb', __FILE__

class AccumuloVisibilityParserSpec < MiniTest::Spec

  # tests derived from https://github.com/apache/accumulo/blob/1.5.1/core/src/main/java/org/apache/accumulo/core/security/ColumnVisibility.java#L418
  it "should parse A" do
    assert_parse "A"
  end

  it "should parse A|B" do
    assert_parse "A|B"
  end

  it "should parse (A|B)&(C|D)" do
    assert_parse "(A|B)&(C|D)"
  end

  it "should parse orange|(red&yellow)" do
    assert_parse "orange|(red&yellow)"
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

  # extra tests

  it "should parse A&B" do
    assert_parse "A&B"
  end

  it "should parse (A)" do
    assert_parse "(A)"
  end

  it "should parse (A|B)" do
    assert_parse "(A|B)"
  end

  it "should parse (A&B)" do
    assert_parse "(A&B)"
  end

  it "should parse A&B&(D|E)&F" do
    assert_parse "A&B&(D|E)&F"
  end

  it "should parse (A&B&(D|E))|F" do
    assert_parse "(A&B&(D|E))|F"
  end

  it "should parse A&B&C&(D|E|F)&G" do
    assert_parse "A&B&C&(D|E|F)&G"
  end

  it "should NOT parse A&B&(D|E)|F" do
    assert_parse_fail "A&B&(D|E)|F"
  end

  def assert_parse s
    AccumuloVisibilityParser.parse(s).str.must_equal "(#{s})"
  end

  def assert_parse_debug s
    puts "Testing #{s}"
    begin
      puts AccumuloVisibilityParser.parse_debug(s)
    rescue Parslet::ParseFailed
    end
    assert_parse s
  end

  def assert_parse_fail s
    begin
      assert_parse s
      fail "Expected #{s} to fail"
    rescue Parslet::ParseFailed
      # do nothing, we should be here
    end
  end

  def assert_parse_fail_debug s
    puts "Testing #{s}"
    puts AccumuloVisibilityParser.parse_debug(s)
    assert_parse_fail s
  end
end
