require File.expand_path '../spec_helper.rb', __FILE__

class AccumuloVisibilityParserSpec < MiniTest::Spec

  before do
    #puts "Before"
  end

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

  # it "should NOT parse A|B&C"
  # it "should NOT parse A=B"
  # it "should NOT parse A|B|"
  # it "should NOT parse A&B"
  # it "should NOT parse ()"
  # it "should NOT parse )"
  # it "should NOT parse dog|!cat"

  def assert_parse s
    AccumuloVisibilityParser.parse(s).str.must_equal s
  end
end
