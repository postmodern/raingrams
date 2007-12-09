require 'raingrams/model'

module Raingrams
  class UnigramModel < Model

    def initialize(opts={},&block)
      opts[:ngram_size] = 1

      super(opts) { |model| model.build(&block) }
    end

    def ngrams_from_words(words)
      words.map { |word| Ngram[word] }
    end

    def ngrams_from_fragment(fragment)
      ngrams_from_words(parse_sentence(fragment))
    end

    def ngrams_from_sentence(sentence)
      ngrams_from_fragment(sentence)
    end

    def ngrams_from_text(text)
      parse_text(text).inject([]) do |ngrams,sentence|
        ngrams + ngrams_from_sentence(sentence)
      end
    end

    def train_with_sentence(sentence)
      train_with_ngrams(ngrams_from_sentence(sentence))
    end

    def train_with_text(text)
      train_with_ngrams(ngrams_from_text(text))
    end

    def gram_count
      @frequency.values.inject do |sum,count|
        sum + count
      end
    end

    def build(&block)
      clear_probabilities

      block.call(self) if block

      total_count = gram_count.to_f
      @frequency.each do |ngram,count|
        @probability[ngram] = count.to_f / total_count
      end

      return self
    end

    def fragment_probability(fragment)
      probability_of_ngrams(ngrams_from_fragment(fragment))
    end

    def sentence_probability(sentence)
      probability_of_ngrams(ngrams_from_sentence(sentence))
    end

    def text_probability(text)
      probability_of_ngrams(ngrams_from_text(text))
    end

  end
end
