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

    @model.ngrams_from_words(words).should == ngrams
  end

  it "should return common ngrams from words" do
    words = %w{The Deliverator is a future Archetype}
    ngrams = [
      Ngram[:The, :Deliverator],
      Ngram[:Deliverator, :is],
      Ngram[:is, :a]
    ]

    @model.common_ngrams_from_words(words).should == ngrams
  end

  it "should return common ngrams from a specified fragment of text" do
    fragment = %{The Deliverator is a future Archetype}
    ngrams = [
      Ngram[:The, :Deliverator],
      Ngram[:Deliverator, :is],
      Ngram[:is, :a]
    ]

    @model.common_ngrams_from_fragment(fragment).should == ngrams
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

    @model.common_ngrams_from_sentence(sentence).should == ngrams
  end

  it "should have a frequency for a specified ngram" do
    ngram = Ngram[:teensy, :darts]

    @model.frequency_of_ngram(ngram).should == 1
  end

  it "should have a probability for a specified ngram" do
    ngram = Ngram[:teensy, :darts]

    @model.probability_of_ngram(ngram).should == 1.0
  end

  it "should have a frequency for specified ngrams" do
    ngrams = NgramSet[
      Ngram[:but, :excess],
      Ngram[:freshly, :napalmed],
      Ngram[:sintered, :armorgel]
    ]

    @model.frequency_of_ngrams(ngrams).should == 3
  end

  it "should have a probability of specified ngrams" do
    ngrams = NgramSet[
      Ngram[:The, :Deliverator],
      Ngram[:Deliverator, :belongs],
      Ngram[:belongs, :to]
    ]
    expected = '0.0112293144208038'.to_f

    @model.probability_of_ngrams(ngrams).should be_within(0.0000000000000001).of(expected)
  end

  it "should have a probability for a specified fragment of text" do
    fragment = %{The Deliverator belongs to}
    expected = '0.0112293144208038'.to_f

    @model.fragment_probability(fragment).should be_within(0.0000000000000001).of(expected)
  end

  it "should have a probability for a specified sentence" do
    sentence = %{The Deliverator used to make software.}
    expected = '4.10042780102381e-07'.to_f

    @model.sentence_probability(sentence).should be_within(0.0000000000000001).of(expected)
  end

  it "should have a probability for specified text" do
    text = %{The Deliverator used to make software. Still does, sometimes.}
    expected = '2.40635434332383e-10'.to_f

    @model.text_probability(text).should be_within(0.0000000000000001).of(expected)
  end
end
