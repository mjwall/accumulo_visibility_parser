require File.expand_path '../spec_helper.rb', __FILE__

class AccumuloVisibilityParserSpec < MiniTest::Spec

  it "should parse A" do
    assert_parse "A"
  end

  it "should parse A|B" do
    assert_parse "A|B"
  end

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

  it "should parse (A|B)&(C|D)" do
    assert_parse "(A|B)&(C|D)"
  end

  it "should parse orange|(red&yellow)" do
    assert_parse "orange|(red&yellow)"
  end

  it "should parse A&B&C&(D|E|F)&G" do
    assert_parse "A&B&C&(D|E|F)&G"
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

  it "should NOT parse A&B&(D|E)|F" do
    assert_parse_fail "A&B&(D|E)|F"
  end

  it "should parse A&B&(D|E)&F" do
    assert_parse "A&B&(D|E)&F"
  end

  it "should parse (A&B&(D|E))|F" do
    #assert_parse "(A&B&(D|E))|F"
  end

  def assert_parse s
    AccumuloVisibilityParser.parse(s).str.must_equal s
  end

  def assert_parse_fail s
    begin
      assert_parse s
      fail "Expected #{s} to fail"
    rescue Parslet::ParseFailed
      # do nothing, we should be here
    end
  end
end
