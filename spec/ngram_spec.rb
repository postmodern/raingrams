require 'raingrams/ngram'

require 'spec_helper'

describe Ngram do
  before(:all) do
    @ngram = Ngram[:one, :two, :three]
  end

  it "should have a prefix" do
    @ngram.prefix.should == Ngram[:one, :two]
  end

  it "should have a postfix" do
    @ngram.postfix.should == Ngram[:two, :three]
  end

  it "should begin with a gram" do
    @ngram.starts_with?(:one).should == true
  end

  it "should end with a gram" do
    @ngram.ends_with?(:three).should == true
  end

  it "should include certain grams" do
    @ngram.includes?(:one, :three).should == true
  end
end
