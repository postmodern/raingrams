module Raingrams
  module Helpers
    module Probability
      #
      # Returns the probability of the specified _ngram_ occurring within
      # arbitrary text.
      #
      def probability_of_ngram(ngram)
        prefix = ngram.prefix

        if @prefixes.has_key?(prefix)
          return @prefixes[prefix].probability_of(ngram.last)
        else
          return 0.0
        end
      end

      #
      # Returns the probability of the specified _ngrams_ occurring within
      # arbitrary text.
      #
      def probabilities_for(ngrams)
        table = {}

        ngrams.each do |ngram|
          table[ngram] = probability_of_ngram(ngram)
        end

        return table
      end

      #
      # Returns the joint probability of the specified _ngrams_ occurring
      # within arbitrary text.
      #
      def probability_of_ngrams(ngrams)
        probabilities_for(ngrams).values.inject do |joint,prob|
          joint * prob
        end
      end

      #
      # Returns the probability of the specified _fragment_ occuring within
      # arbitrary text.
      #
      def fragment_probability(fragment)
        probability_of_ngrams(ngrams_from_fragment(fragment))
      end

      #
      # Returns the probability of the specified _sentence_ occuring within
      # arbitrary text.
      #
      def sentence_probability(sentence)
        probability_of_ngrams(ngrams_from_sentence(sentence))
      end

      #
      # Returns the probability of the specified _text_ occuring within
      # arbitrary text.
      #
      def text_probability(text)
        probability_of_ngrams(ngrams_from_text(text))
      end
    end
  end
end
