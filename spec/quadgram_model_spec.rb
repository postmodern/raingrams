require 'raingrams/quadgram_model'

require 'spec_helper'
require 'model_examples'

describe QuadgramModel do
  before(:all) do
    @model = QuadgramModel.build do |model|
      model.train_with_text(Training.text_for(:snowcrash))
    end
  end

  it_should_behave_like "Model"

  it "should return ngrams from specified words" do
    words = %w{Why is the Deliverator so equipped}
    ngrams = [
      Ngram[:Why, :is, :the, :Deliverator],
      Ngram[:is, :the, :Deliverator, :so],
      Ngram[:the, :Deliverator, :so, :equipped]
    ]

    expect(@model.ngrams_from_words(words)).to eq(ngrams)
  end

  it "should return common ngrams from words" do
    words = %w{The Deliverator is a future Archetype}
    ngrams = [
      Ngram[:The, :Deliverator, :is, :a]
    ]

    expect(@model.common_ngrams_from_words(words)).to eq(ngrams)
  end

  it "should return common ngrams from a specified fragment of text" do
    fragment = %{The Deliverator is a future Archetype}
    ngrams = [
      Ngram[:The, :Deliverator, :is, :a]
    ]

    expect(@model.common_ngrams_from_fragment(fragment)).to eq(ngrams)
  end

  it "should return common ngrams from a specified sentence" do
    sentence = %{The Deliverator is a future Archetype.}
    ngrams = [
      Ngram[Tokens.start, Tokens.start, Tokens.start, Tokens.start],
      Ngram[Tokens.start, Tokens.start, Tokens.start, :The],
      Ngram[Tokens.start, Tokens.start, :The, :Deliverator],
      Ngram[Tokens.start, :The, :Deliverator, :is],
      Ngram[:The, :Deliverator, :is, :a],
      Ngram[Tokens.stop, Tokens.stop, Tokens.stop, Tokens.stop]
    ]

    expect(@model.common_ngrams_from_sentence(sentence)).to eq(ngrams)
  end

  it "should have a frequency for a specified ngram" do
    ngram = Ngram[:it, :fires, :teensy, :darts]

    expect(@model.frequency_of_ngram(ngram)).to eq(1)
  end

  it "should have a probability for a specified ngram" do
    ngram = Ngram[:it, :fires, :teensy, :darts]

    expect(@model.probability_of_ngram(ngram)).to eq(1.0)
  end

  it "should have a frequency for specified ngrams" do
    ngrams = NgramSet[
      Ngram[:but, :excess, :perspiration, :wafts],
      Ngram[:a, :freshly, :napalmed, :forest],
      Ngram[:suit, :has, :sintered, :armorgel]
    ]

    expect(@model.frequency_of_ngrams(ngrams)).to eq(3)
  end

  it "should have a probability of specified ngrams" do
    ngrams = NgramSet[
      Ngram[:The, :Deliverator, :belongs, :to],
      Ngram[:Deliverator, :belongs, :to, :an]
    ]

    expect(@model.probability_of_ngrams(ngrams).to_s).to eq('1.0')
  end

  it "should have a probability for a specified fragment of text" do
    fragment = %{The Deliverator belongs to}

    expect(@model.fragment_probability(fragment).to_s).to eq('1.0')
  end

  it "should have a probability for a specified sentence" do
    sentence = %{So now he has this other job.}
    expected = '0.00117370892018779'.to_f

    expect(@model.sentence_probability(sentence)).to be_within(0.0000000000000001).of(expected)
  end

  it "should have a probability for specified text" do
    text = %{So now he has this other job. No brightness or creativity involved-but no cooperation either.}
    expected = '2.75518525865679e-06'.to_f

    expect(@model.text_probability(text)).to be_within(0.0000000000000001).of(expected)
  end
end
