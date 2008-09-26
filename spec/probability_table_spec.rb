require 'raingrams/probability_table'

require 'spec_helper'

describe ProbabilityTable do
  before(:all) do
    @grams = [:a, :b, :a, :a, :b, :c, :d, 2, 3, :a]

    @table = ProbabilityTable.new
    @grams.each { |g| @table.count(g) }
  end

  describe "empty table" do
    before(:all) do
      @empty_table = ProbabilityTable.new
    end

    it "should not be dirty" do
      @empty_table.should_not be_dirty
    end

    it "should be empty" do
      @empty_table.should be_empty
    end

    it "should not have any frequencies" do
      @empty_table.frequencies.should be_empty
    end

    it "should have no probabilities" do
      @empty_table.probabilities.should be_empty
    end

    it "should have no grams" do
      @empty_table.grams.should be_empty
    end
  end

  describe "un-built table" do
    it "should be dirty" do
      @table.should be_dirty
    end

    it "should have the observed grams" do
      (@table.grams - @grams.uniq).should be_empty
    end

    it "should have non-zero frequencies" do
      @table.frequencies.each_value do |freq|
        freq.should > 0
      end
    end

    it "should have non-zero frequencies for grams it has observed" do
      @grams.uniq.each do |g|
        @table.frequency_of(g).should > 0
      end
    end

    it "should return a zero frequency for unknown grams" do
      @table.frequency_of(:x).should == 0
    end

    it "should not have any probabilities yet" do
      @table.probabilities.should be_empty
    end
  end

  describe "built table" do
    before(:all) do
      @table.build
    end

    it "should not be dirty" do
      @table.should_not be_dirty
    end

    it "should return a zero probability for unknown grams" do
      @table.probability_of(:x).should == 0.0
    end

    it "should have non-zero probabilities" do
      @table.probabilities.each_value do |prob|
        prob.should > 0.0
      end
    end

    it "should have non-zero probabilities for grams it has observed" do
      @grams.uniq.each do |g|
        @table.probability_of(g).should > 0.0
      end
    end
  end
end
