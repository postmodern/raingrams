require 'raingrams/ngram'
require 'raingrams/tokens/start_sentence'
require 'raingrams/tokens/stop_sentence'
require 'raingrams/exceptions/prefix_frequency_missing'

module Raingrams
  class Model

    # Size of ngrams to use
    attr_reader :ngram_size

    # Ignore case of parsed text
    attr_reader :ignore_case

    # Ignore the punctuation of parsed text
    attr_reader :ignore_punc

    # Ignore URLs
    attr_reader :ignore_urls

    # Ignore Phone numbers
    attr_reader :ignore_phone_numbers

    # Ignore References
    attr_reader :ignore_references

    # Frequencies of observed ngrams
    attr_reader :frequency

    # Normalized table of observed ngrams
    attr_reader :probability

    def initialize(options={},&block)
      @ngram_size = options[:ngram_size]
      @ignore_case = (options[:ignore_case] || false)
      @ignore_punc = (options[:ignore_punc] || true)
      @ignore_urls = (options[:ignore_urls] || false)
      @ignore_phone_numbers = (options[:ignore_phone_numbers] || false)

      @frequency = Hash.new { |hash,key| 0 }
      @probability = Hash.new { |hash,key| 0.0 }

      block.call(self) if block
    end

    def parse_sentence(sentence)
      sentence = sentence.to_s.gsub(/[\.\?!]$/,'')

      if @ignore_urls
        sentence.gsub!(/\s*\w+:\/\/\w*\s*/,' ')
      end

      if @ignore_phone_numbers
        sentence.gsub!(/\s*(\d-)?(\d{3}-)?\d{3}-\d{4}\s*/,' ')
      end

      if @ignore_references
        sentence.gsub!(/\s*[\d+]\s*/,' ')
      end

      if @ignore_case
        sentence.downcase!
      end

      if @ignore_punc
        return sentence.scan(/\w+[\.'\-\_]?\w*/)
      else
        return sentence.scan(/(\w+|[-_,\.;'"])/)
      end
    end

    def parse_text(text,&block)
      text.to_s.scan(/[^\s\.\?!][^\.\?!]*/)
    end

    def train_with_ngram(ngram)
      @frequency[ngram] += 1
      return self
    end

    def train_with_ngrams(ngrams=[])
      ngrams.each { |ngram| train_with_ngram(ngram) }
      return self
    end

    def ngrams
      @frequency.keys
    end

    def has_ngram?(ngram)
      ngrams.include?(ngram)
    end

    def each_ngram(&block)
      ngrams.each(&block)
    end

    def ngrams_with(&block)
      ngrams.select(&block)
    end

    def vocabulary
      ngrams.flatten.uniq
    end

    def within_vocabulary?(gram)
      each_ngrams do |ngram|
        return true if ngram.include?(gram)
      end

      return false
    end

    def ngrams_starting_with(obj)
      ngrams_with { |ngram| ngram.starts_with?(obj.to_gram) }
    end

    def ngrams_ending_with(gram)
      ngrams_with { |ngram| ngram.ends_with?(gram) }
    end

    def probabilities_for(ngrams)
      ngrams.map { |ngram| @probability[ngram] }
    end

    def probability_of_ngram(ngram)
      @probability[ngram]
    end

    def probability_of_ngrams(ngrams)
      probabilities_for(ngrams).inject { |joint,prob| joint * prob }
    end

    def probability_of_gram(gram)
      probability_of_ngrams(ngrams_starting_with(gram))
    end

    def clear
      @frequency.clear

      clear_probabilities
      return self
    end

    protected

    def clear_probabilities
      @probability.clear
      return self
    end

  end
end
