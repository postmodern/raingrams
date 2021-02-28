require 'spec_helper'

shared_examples_for "Model" do
  it "should have ngrams" do
    @model.ngrams.each do |ngram|
      expect(@model.has_ngram?(ngram)).to eq(true)
    end
  end

  it "should be able to iterate through all ngrams" do
    @model.each_ngram do |ngram|
      expect(@model.has_ngram?(ngram)).to eq(true)
    end
  end

  it "should be able to select ngrams with certain properties" do
    ngrams = @model.ngrams_with do |ngram|
      ngram.include?(:the)
    end

    ngrams.each do |ngram|
      expect(ngram.include?(:the)).to eq(true)
    end
  end

  it "should be able to select ngrams starting with a specified gram" do
    @model.ngrams_starting_with(:filtering).each do |ngram|
      expect(ngram.starts_with?(:filtering)).to eq(true)
    end
  end

  it "should be able to select ngrams ending with a specified gram" do
    @model.ngrams_ending_with(:sword).each do |ngram|
      expect(ngram.ends_with?(:sword)).to eq(true)
    end
  end

  it "should be able to select ngrams including any of the specified grams" do
    @model.ngrams_including_any(:The, :Deliverator).each do |ngram|
      expect(ngram.includes_any?(:The, :Deliverator)).to eq(true)
    end
  end

  it "should be able to select ngrams including all of the specified grams" do
    @model.ngrams_including_all(:activated, :charcoal).each do |ngram|
      expect(ngram.includes_all?(:activated, :charcoal)).to eq(true)
    end
  end

  it "should have grams" do
    @model.grams.each do |gram|
      expect(@model.has_gram?(gram)).to eq(true)
    end
  end

  it "should provide a random ngram" do
    expect(@model.has_ngram?(@model.random_ngram)).to eq(true)
  end

  it "should generate a random sentence" do
    sentence = @model.random_sentence

    @model.ngrams_from_sentence(sentence).each do |ngram|
      expect(@model.has_ngram?(ngram)).to eq(true)
    end
  end

  it "should generate a random paragraph" do
    paragraph = @model.random_paragraph

    @model.ngrams_from_paragraph(paragraph).each do |ngram|
      expect(@model.has_ngram?(ngram)).to eq(true)
    end
  end

  it "should generate a random text" do
    text = @model.random_text

    @model.ngrams_from_text(text).each do |ngram|
      expect(@model.has_ngram?(ngram)).to eq(true)
    end
  end
end
