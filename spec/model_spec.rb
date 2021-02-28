require 'spec_helper'

require 'raingrams/model'

describe Model do
  before(:all) do
    @model = Model.new(:ngram_size => 2)

    @phone_number_model = Model.new(
      :ngram_size => 2,
      :ignore_phone_numbers => true
    )

    @references_model = Model.new(
      :ngram_size => 2,
      :ignore_references => true
    )

    @case_model = Model.new(
      :ngram_size => 2,
      :ignore_case => true
    )

    @punctuation_model = Model.new(
      :ngram_size => 2,
      :ignore_punctuation => false
    )
  end

  it "should parse text into sentences" do
    text = %{The Deliverator belongs to an elite order, a hallowed sub-category. He's got esprit up to here.}
    sentences = [
      "The Deliverator belongs to an elite order, a hallowed sub-category.",
      "He's got esprit up to here."
    ]

    expect(@model.parse_text(text)).to eq(sentences)
  end

  it "should parse words from a sentence" do
    sentence = %{The Deliverator is in touch with the road, starts like a bad day, stops on a peseta.}
    words = %w{The Deliverator is in touch with the road starts like a bad day stops on a peseta}

    expect(@model.parse_sentence(sentence)).to eq(words)
  end

  it "should ignore URLs by default while parsing a sentence" do
    sentence = %{Click on the following link: http://www.example.com/}
    words = %w{Click on the following link}

    expect(@model.parse_sentence(sentence)).to eq(words)
  end

  it "should ignore short URIs by default while parsing a sentence" do
    sentence = %{Click on the following link: jabber://}
    words = %w{Click on the following link}

    expect(@model.parse_sentence(sentence)).to eq(words)
  end

  it "should ignore complex HTTP URLs by default while parsing a sentence" do
    sentence = %{Click on the following link: http://www.google.com/search?hl=en&client=firefox-a&rls=org.mozilla:en-US:official&hs=jU&q=ruby+datamapper&start=20&sa=N}
    words = %w{Click on the following link}

    expect(@model.parse_sentence(sentence)).to eq(words)
  end

  it "may ignore phone numbers while parsing a sentence" do
    sentence = %{Call me before 12, 1-888-444-2222.}
    words = %w{Call me before 12}

    expect(@phone_number_model.parse_sentence(sentence)).to eq(words)
  end

  it "may ignore long-distance phone numbers while parsing a sentence" do
    sentence = %{Call me before 12, 1-444-2222.}
    words = %w{Call me before 12}

    expect(@phone_number_model.parse_sentence(sentence)).to eq(words)
  end

  it "may ignore short phone numbers while parsing a sentence" do
    sentence = %{Call me before 12, 444-2222.}
    words = %w{Call me before 12}

    expect(@phone_number_model.parse_sentence(sentence)).to eq(words)
  end

  it "may ignore RFC style references while parsing a sentence" do
    sentence = %{As one can see, it has failed [1].}
    words = %w{As one can see it has failed}

    expect(@references_model.parse_sentence(sentence)).to eq(words)
  end

  it "should ignore punctuation by default while parsing a sentence" do
    sentence = %{Oh, they used to argue over times, many corporate driver-years lost to it: homeowners, red-faced and sweaty with their own lies, stinking of Old Spice and job-related stress, standing in their glowing yellow doorways brandishing their Seikos and waving at the clock over the kitchen sink, I swear, can't you guys tell time?}
    words = %w{
      Oh they used to argue over times many corporate driver-years lost to it homeowners red-faced and sweaty with their own lies stinking of Old Spice and job-related stress standing in their glowing yellow doorways brandishing their Seikos and waving at the clock over the kitchen sink I swear can't you guys tell time
    }

    expect(@model.parse_sentence(sentence)).to eq(words)
  end

  it "may ignore case while parsing a sentence" do
    sentence = %{The Deliverator is in touch with the road, starts like a bad day, stops on a peseta.}
    words = %w{the deliverator is in touch with the road starts like a bad day stops on a peseta}

    expect(@case_model.parse_sentence(sentence)).to eq(words)
  end

  it "may preserve punctuation while parsing a sentence" do
    sentence = %{Oh, they used to argue over times, many corporate driver-years lost to it: homeowners, red-faced and sweaty with their own lies, stinking of Old Spice and job-related stress, standing in their glowing yellow doorways brandishing their Seikos and waving at the clock over the kitchen sink, I swear, can't you guys tell time?}
    words = %w{Oh, they used to argue over times, many corporate driver-years lost to it: homeowners, red-faced and sweaty with their own lies, stinking of Old Spice and job-related stress, standing in their glowing yellow doorways brandishing their Seikos and waving at the clock over the kitchen sink, I swear, can't you guys tell time?}

    expect(@punctuation_model.parse_sentence(sentence)).to eq(words)
  end
end
