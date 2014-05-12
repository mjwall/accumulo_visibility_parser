require File.expand_path '../spec_helper.rb', __FILE__

class AccumuloVisibilityParserSpec < MiniTest::Spec

  before do
    #puts "Before"
  end

  it "should parse A" do
    str = "A"
    AccumuloVisibilityParser.parse(str).str.must_equal str
  end

  it "should parse A|B" do
    str = "A|B"
    AccumuloVisibilityParser.parse(str).str.must_equal str
  end

  it "should parse (A|B)&(C|D)"
  it "should parse orange|(red&yellow)"
  it "should NOT parse A|B&C"
  it "should NOT parse A=B"
  it "should NOT parse A|B|"
  it "should NOT parse A&B"
  it "should NOT parse ()"
  it "should NOT parse )"
  it "should NOT parse dog|!cat"
end
