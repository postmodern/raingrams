require 'raingrams/bigram_model'

require 'spec_helper'
require 'model_examples'

describe BigramModel do
  before(:all) do
    @model = BigramModel.train_with_text(Training.text_for(:snowcrash))
  end

  it_should_behave_like "Model"

  it "should return ngrams from specified words" do
    words = %w{Why is the Deliverator so equipped}
    ngrams = [
      Ngram[:Why, :is],
      Ngram[:is, :the],
      Ngram[:the, :Deliverator],
      Ngram[:Deliverator, :so],
      Ngram[:so, :equipped]
    ]

    expect(@model.ngrams_from_words(words)).to eq(ngrams)
  end

  it "should return common ngrams from words" do
    words = %w{The Deliverator is a future Archetype}
    ngrams = [
      Ngram[:The, :Deliverator],
      Ngram[:Deliverator, :is],
      Ngram[:is, :a]
    ]

    expect(@model.common_ngrams_from_words(words)).to eq(ngrams)
  end

  it "should return common ngrams from a specified fragment of text" do
    fragment = %{The Deliverator is a future Archetype}
    ngrams = [
      Ngram[:The, :Deliverator],
      Ngram[:Deliverator, :is],
      Ngram[:is, :a]
    ]

    expect(@model.common_ngrams_from_fragment(fragment)).to eq(ngrams)
  end

  it "should return common ngrams from a specified sentence" do
    sentence = %{The Deliverator is a future Archetype.}
    ngrams = [
      Ngram[Tokens.start, Tokens.start],
      Ngram[Tokens.start, :The],
      Ngram[:The, :Deliverator],
      Ngram[:Deliverator, :is],
      Ngram[:is, :a],
      Ngram[Tokens.stop, Tokens.stop]
    ]

    expect(@model.common_ngrams_from_sentence(sentence)).to eq(ngrams)
  end

  it "should have a frequency for a specified ngram" do
    ngram = Ngram[:teensy, :darts]

    expect(@model.frequency_of_ngram(ngram)).to eq(1)
  end

  it "should have a probability for a specified ngram" do
    ngram = Ngram[:teensy, :darts]

    expect(@model.probability_of_ngram(ngram)).to eq(1.0)
  end

  it "should have a frequency for specified ngrams" do
    ngrams = NgramSet[
      Ngram[:but, :excess],
      Ngram[:freshly, :napalmed],
      Ngram[:sintered, :armorgel]
    ]

    expect(@model.frequency_of_ngrams(ngrams)).to eq(3)
  end

  it "should have a probability of specified ngrams" do
    ngrams = NgramSet[
      Ngram[:The, :Deliverator],
      Ngram[:Deliverator, :belongs],
      Ngram[:belongs, :to]
    ]
    expected = '0.0112293144208038'.to_f

    expect(@model.probability_of_ngrams(ngrams)).to be_within(0.0000000000000001).of(expected)
  end

  it "should have a probability for a specified fragment of text" do
    fragment = %{The Deliverator belongs to}
    expected = '0.0112293144208038'.to_f

    expect(@model.fragment_probability(fragment)).to be_within(0.0000000000000001).of(expected)
  end

  it "should have a probability for a specified sentence" do
    sentence = %{The Deliverator used to make software.}
    expected = '4.10042780102381e-07'.to_f

    expect(@model.sentence_probability(sentence)).to be_within(0.0000000000000001).of(expected)
  end

  it "should have a probability for specified text" do
    text = %{The Deliverator used to make software. Still does, sometimes.}
    expected = '2.40635434332383e-10'.to_f

    expect(@model.text_probability(text)).to be_within(0.0000000000000001).of(expected)
  end
end
