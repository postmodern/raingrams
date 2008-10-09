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
    @ngrams.select { |ngram|
      ngram.starts_with?(:the)
    }.should == NgramSet[Ngram[:the, :dog], Ngram[:the, :hoop]]
  end

  it "should select ngrams with a specified prefixed" do
    @ngrams.prefixed_by(Ngram[:dog]).should == NgramSet[
      Ngram[:dog, :jumped]
    ]
  end

  it "should select ngrams with a specified postfix" do
    @ngrams.postfixed_by(Ngram[:through]).should == NgramSet[
      Ngram[:jumped, :through]
    ]
  end

  it "should select ngrams starting with a specified gram" do
    @ngrams.starts_with(:jumped).should == NgramSet[Ngram[:jumped, :through]]
  end

  it "should select ngrams ending with a specified gram" do
    @ngrams.ends_with(:dog).should == NgramSet[Ngram[:the, :dog]]
  end

  it "should select ngrams including a specified gram" do
    @ngrams.including(:dog).should == NgramSet[
      Ngram[:the, :dog],
      Ngram[:dog, :jumped]
    ]
  end

  it "should select ngrams which include any of the specified grams" do
    @ngrams.including_any(:the, :dog).should == NgramSet[
      Ngram[:the, :dog],
      Ngram[:dog, :jumped],
      Ngram[:through, :the],
      Ngram[:the, :hoop]
    ]
  end

  it "should select ngrams which include all of the specified grams" do
    @ngrams.including_all(:the, :dog).should == NgramSet[
      Ngram[:the, :dog]
    ]
  end
end
