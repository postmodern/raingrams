require 'raingrams/trigram_model'

require 'spec_helper'
require 'model_examples'

describe TrigramModel do
  before(:all) do
    @model = TrigramModel.build do |model|
      model.train_with_text(Training.text_for(:snowcrash))
    end
  end

  it_should_behave_like "Model"

  it "should return ngrams from specified words" do
    words = %w{Why is the Deliverator so equipped}
    ngrams = [
      Ngram[:Why, :is, :the],
      Ngram[:is, :the, :Deliverator],
      Ngram[:the, :Deliverator, :so],
      Ngram[:Deliverator, :so, :equipped]
    ]

    expect(@model.ngrams_from_words(words)).to eq(ngrams)
  end

  it "should return common ngrams from words" do
    words = %w{The Deliverator is a future Archetype}
    ngrams = [
      Ngram[:The, :Deliverator, :is],
      Ngram[:Deliverator, :is, :a]
    ]

    expect(@model.common_ngrams_from_words(words)).to eq(ngrams)
  end

  it "should return common ngrams from a specified fragment of text" do
    fragment = %{The Deliverator is a future Archetype}
    ngrams = [
      Ngram[:The, :Deliverator, :is],
      Ngram[:Deliverator, :is, :a]
    ]

    expect(@model.common_ngrams_from_fragment(fragment)).to eq(ngrams)
  end

  it "should return common ngrams from a specified sentence" do
    sentence = %{The Deliverator is a future Archetype.}
    ngrams = [
      Ngram[Tokens.start, Tokens.start, Tokens.start],
      Ngram[Tokens.start, Tokens.start, :The],
      Ngram[Tokens.start, :The, :Deliverator],
      Ngram[:The, :Deliverator, :is],
      Ngram[:Deliverator, :is, :a],
      Ngram[Tokens.stop, Tokens.stop, Tokens.stop]
    ]

    expect(@model.common_ngrams_from_sentence(sentence)).to eq(ngrams)
  end

  it "should have a frequency for a specified ngram" do
    ngram = Ngram[:fires, :teensy, :darts]

    expect(@model.frequency_of_ngram(ngram)).to eq(1)
  end

  it "should have a probability for a specified ngram" do
    ngram = Ngram[:fires, :teensy, :darts]

    expect(@model.probability_of_ngram(ngram)).to eq(1.0)
  end

  it "should have a frequency for specified ngrams" do
    ngrams = NgramSet[
      Ngram[:but, :excess, :perspiration],
      Ngram[:freshly, :napalmed, :forest],
      Ngram[:has, :sintered, :armorgel]
    ]

    expect(@model.frequency_of_ngrams(ngrams)).to eq(3)
  end

  it "should have a probability of specified ngrams" do
    ngrams = NgramSet[
      Ngram[:The, :Deliverator, :belongs],
      Ngram[:Deliverator, :belongs, :to]
    ]
    expected = '0.0526315789473684'.to_f

    expect(@model.probability_of_ngrams(ngrams)).to be_within(0.0000000000000001).of(expected)
  end

  it "should have a probability for a specified fragment of text" do
    fragment = %{The Deliverator belongs to}
    expected = '0.0526315789473684'.to_f

    expect(@model.fragment_probability(fragment)).to be_within(0.0000000000000001).of(expected)
  end

  it "should have a probability for a specified sentence" do
    sentence = %{The Deliverator used to make software.}
    expected = '0.000262540153199901'.to_f

    expect(@model.sentence_probability(sentence)).to be_within(0.0000000000000001).of(expected)
  end

  it "should have a probability for specified text" do
    text = %{The Deliverator used to make software. Still does, sometimes.}
    expected = '6.16291439436388e-07'.to_f
    expect(@model.text_probability(text)).to be_within(0.0000000000000001).of(expected)
  end
end
