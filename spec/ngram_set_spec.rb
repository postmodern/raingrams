require 'raingrams/ngram_set'

require 'spec_helper'

describe NgramSet do
  before(:all) do
    @ngrams = NgramSet[
      Ngram[:the, :dog],
      Ngram[:dog, :jumped],
      Ngram[:jumped, :through],
      Ngram[:through, :the],
      Ngram[:the, :hoop]
    ]
  end

  it "should select ngrams from the set" do
    expect(@ngrams.select { |ngram|
      ngram.starts_with?(:the)
    }).to eq(NgramSet[Ngram[:the, :dog], Ngram[:the, :hoop]])
  end

  it "should select ngrams with a specified prefixed" do
    expect(@ngrams.prefixed_by(Ngram[:dog])).to eq(NgramSet[
      Ngram[:dog, :jumped]
    ])
  end

  it "should select ngrams with a specified postfix" do
    expect(@ngrams.postfixed_by(Ngram[:through])).to eq(NgramSet[
      Ngram[:jumped, :through]
    ])
  end

  it "should select ngrams starting with a specified gram" do
    expect(@ngrams.starts_with(:jumped)).to eq(NgramSet[Ngram[:jumped, :through]])
  end

  it "should select ngrams ending with a specified gram" do
    expect(@ngrams.ends_with(:dog)).to eq(NgramSet[Ngram[:the, :dog]])
  end

  it "should select ngrams including a specified gram" do
    expect(@ngrams.including(:dog)).to eq(NgramSet[
      Ngram[:the, :dog],
      Ngram[:dog, :jumped]
    ])
  end

  it "should select ngrams which include any of the specified grams" do
    expect(@ngrams.including_any(:the, :dog)).to eq(NgramSet[
      Ngram[:the, :dog],
      Ngram[:dog, :jumped],
      Ngram[:through, :the],
      Ngram[:the, :hoop]
    ])
  end

  it "should select ngrams which include all of the specified grams" do
    expect(@ngrams.including_all(:the, :dog)).to eq(NgramSet[
      Ngram[:the, :dog]
    ])
  end
end
