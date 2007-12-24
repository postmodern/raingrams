require 'raingrams/model'
require 'raingrams/tokens/start_sentence'
require 'raingrams/tokens/stop_sentence'
require 'raingrams/exceptions/prefix_frequency_missing'

module Raingrams
  class MultigramModel < Model

    # Frequencies of n-1 grams
    attr_reader :prefix_frequency

    def initialize(opts={},&block)
      @prefix_frequency = Hash.new { |hash,key| 0 }

      super(opts) { |model| model.build(&block) }
    end

    def ngrams_from_words(words)
      return (0...(words.length-@ngram_size+1)).map do |index|
        Ngram.new(words[index,@ngram_size])
      end
    end

    def ngrams_from_fragment(fragment)
      ngrams_from_words(parse_sentence(fragment))
    end

    def ngrams_from_sentence(sentence)
      ngrams_from_words(wrap_sentence(parse_sentence(sentence)))
    end

    def ngrams_from_text(text)
      parse_text(text).inject([]) do |ngrams,sentence|
        ngrams + ngrams_from_sentence(sentence)
      end
    end

    def common_ngrams_from_words(words)
      ngrams_from_words(words).select { |ngram| has_ngram?(ngram) }
    end

    def common_ngrams_from_fragment(fragment)
      ngrams_from_fragment(words).select { |ngram| has_ngram?(ngram) }
    end

    def common_ngrams_from_sentence(sentence)
      ngrams_from_sentence(sentence).select { |ngram| has_ngram?(ngram) }
    end

    def common_ngrams_from_text(text)
      ngrams_from_text(text).select { |ngram| has_ngram?(ngram) }
    end

    def train_with_ngram(ngram)
      @prefix_frequency[ngram.prefix] += 1
      return super(ngram)
    end

    def train_with_sentence(sentence)
      train_with_ngrams(ngrams_from_sentence(sentence))
    end

    def train_with_text(text)
      train_with_ngrams(ngrams_from_text(text))
    end

    def build(&block)
      clear_probabilities

      block.call(self) if block

      @frequency.each do |ngram,count|
        prefix = ngram.prefix

        unless @prefix_frequency[prefix]
          raise(PrefixFrequencyMissing,"the model is missing the frequency of the ngram prefix #{prefix}",caller)
        end

        @probability[ngram] = count.to_f / @prefix_frequency[prefix].to_f
      end

      return self
    end

    def ngrams_prefixed_by(prefix)
      ngrams_with { |ngram| ngram.prefixed_by?(prefix) }
    end

    def ngrams_postfixed_by(postfix)
      ngrams_with { |ngram| ngram.prefixed_by?(postfix) }
    end

    def ngrams_preceeding(gram)
      ngrams_ending_with(gram).map do |ngram|
        ngrams_postfixed_by(ngram.prefix)
      end
    end

    def ngrams_following(gram)
      ngrams_starting_with(gram).map do |ngram|
        ngrams_prefixed_by(ngram.postfix)
      end
    end

    def grams_preceeding(gram)
      ngrams_ending_with(gram).map do |ngram|
        ngram[-2]
      end
    end

    def grams_following(gram)
      ngrams_starting_with(gram).map do |ngram|
        ngram[1]
      end
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

    def common_fragment_probability(fragment)
      probability_of_ngrams(common_ngrams_from_fragment(fragment))
    end

    def common_sentence_probability(sentence)
      probability_of_ngrams(common_ngrams_from_sentence(sentence))
    end

    def common_text_probability(fragment)
      probability_of_ngrams(common_ngrams_from_text(text))
    end

    def similar_fragment_probability(other,fragment)
      common_fragment_probability(fragment) * other.common_fragment_probability(fragment)
    end

    def similar_sentence_probability(other,sentence)
      common_sentence_probability(sentence) * other.common_sentence_probability(sentence)
    end

    def similar_text_probability(other,text)
      common_text_probability(text) * other.common_text_probability(text)
    end

    def clear
      @prefix_frequency.clear
      return super
    end

    protected

    def wrap_sentence(sentence)
      (Tokens::StartSentence * @ngram_size) + sentence.to_a + (Tokens::StopSentence * @ngram_size)
    end

  end
end
