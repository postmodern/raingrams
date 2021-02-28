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
      expect(@empty_table).not_to be_dirty
    end

    it "should be empty" do
      expect(@empty_table).to be_empty
    end

    it "should not have any frequencies" do
      expect(@empty_table.frequencies).to be_empty
    end

    it "should have no probabilities" do
      expect(@empty_table.probabilities).to be_empty
    end

    it "should have no grams" do
      expect(@empty_table.grams).to be_empty
    end
  end

  describe "un-built table" do
    it "should be dirty" do
      expect(@table).to be_dirty
    end

    it "should have the observed grams" do
      expect(@table.grams - @grams.uniq).to be_empty
    end

    it "should have non-zero frequencies" do
      @table.frequencies.each_value do |freq|
        expect(freq).to be > 0
      end
    end

    it "should have non-zero frequencies for grams it has observed" do
      @grams.uniq.each do |g|
        expect(@table.frequency_of(g)).to be > 0
      end
    end

    it "should return a zero frequency for unknown grams" do
      expect(@table.frequency_of(:x)).to eq(0)
    end

    it "should not have any probabilities yet" do
      expect(@table.probabilities).to be_empty
    end
  end

  describe "built table" do
    before(:all) do
      @table.build
    end

    it "should not be dirty" do
      expect(@table).not_to be_dirty
    end

    it "should return a zero probability for unknown grams" do
      expect(@table.probability_of(:x)).to eq(0.0)
    end

    it "should have non-zero probabilities" do
      @table.probabilities.each_value do |prob|
        expect(prob).to be > 0.0
      end
    end

    it "should have non-zero probabilities for grams it has observed" do
      @grams.uniq.each do |g|
        expect(@table.probability_of(g)).to be > 0.0
      end
    end
  end
end
