require File.expand_path '../../spec_helper.rb', __FILE__

class RoleCheckerSpec < MiniTest::Spec

  before do
    @e = AccumuloVisibilityParser::RoleChecker.new(['A','B','C','E','G'])
  end

  it "#new should default to empty roles" do
    AccumuloVisibilityParser::RoleChecker.new.roles.must_equal []
  end

  it "#new should handle a single role" do
    AccumuloVisibilityParser::RoleChecker.new("A").roles.must_equal ["A"]
  end

  it "#new should handle roles" do
    roles = ['A','B']
    AccumuloVisibilityParser::RoleChecker.new(roles).roles.must_equal roles
  end

  it "#new should handle nested roles" do
    roles = ['A','B',['C','D']]
    AccumuloVisibilityParser::RoleChecker.new(roles).roles.must_equal roles.flatten
  end

  it "#roles= should fail" do
    begin
      @e.roles= ["A","B"]
      fail "Go elsewhere"
    rescue => e
      e.message.must_match 'undefined method'
    end
  end

  it "#evaluate should error if visiblity fails to parse" do
    begin
      @e.evaluate("A=B")
      fail "don't be here"
    rescue => e
      e.class.must_equal Parslet::ParseFailed
      e.message.must_match "Failed to match"
    end
  end

  it "#evaluate should return true if empty visiblity" do
    @e.evaluate.must_equal true
    @e.evaluate(nil).must_equal true
    @e.evaluate("").must_equal true
  end

  it "#evaluate should return true if no roles and no visibility" do
    AccumuloVisibilityParser::RoleChecker.new.evaluate.must_equal true
  end

  it "#evaluate should return false if visibility but no roles" do
    AccumuloVisibilityParser::RoleChecker.new.evaluate("A&B").must_equal false
  end

  it "#evaluate should return true when roles do satisfy AND visibility" do
    @e.evaluate("A&B").must_equal true
  end

  it "#evaluate should return true when roles do satisfy OR visibility" do
    @e.evaluate("A|B").must_equal true
  end

  it "#evaluate should return true when roles do satisfy AND visibility with nested OR" do
    @e.evaluate("A&B&(C|D)").must_equal true
  end

  it "#evaluate should return true when roles do satisfy AND visibility double nested OR" do
    @e.evaluate("(C|D)&(A|B)").must_equal true
  end

  it "#evaluate should return true when roles do satisfy AND visibility inner nested OR" do
    @e.evaluate("A&B&C&(D|E|F)&G").must_equal true
  end

  it "#evaluate should return false when roles do NOT satisfy AND visibility" do
    @e.evaluate("A&J").must_equal false
  end

  it "#evaluate should return false when roles do NOT satisfy OR visibility" do
    @e.evaluate("K|L").must_equal false
  end

  it "#evaluate should return false when roles do NOT satisfy AND visibility with nested OR" do
    @e.evaluate("A&B&(F|D)").must_equal false
  end

  it "#evaluate should return false when roles do NOT satisfy AND visibility double nested OR" do
    @e.evaluate("(K|H)&(A|B)").must_equal false
  end

  it "#evaluate should return false when roles do NOT satisfy AND visibility inner nested OR" do
    @e.evaluate("A&B&C&(D|E|F)&H").must_equal false
  end
end
