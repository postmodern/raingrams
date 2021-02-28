require 'raingrams/ngram'

require 'spec_helper'

describe Ngram do
  before(:all) do
    @ngram = Ngram[:one, :two, :three]
  end

  it "should have a prefix" do
    expect(@ngram.prefix).to eq(Ngram[:one, :two])
  end

  it "should have a postfix" do
    expect(@ngram.postfix).to eq(Ngram[:two, :three])
  end

  it "should begin with a gram" do
    expect(@ngram.starts_with?(:one)).to eq(true)
  end

  it "should end with a gram" do
    expect(@ngram.ends_with?(:three)).to eq(true)
  end

  it "should include certain grams" do
    expect(@ngram.includes_all?(:one, :three)).to eq(true)
  end
end
