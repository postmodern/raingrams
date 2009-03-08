require 'raingrams/helpers/probability'

module Raingrams
  module Helpers
    module Commonality
      def self.included(base)
        base.module_eval { include Raingrams::Helpers::Probability }
      end

      #
      # Returns the ngrams which occur within the specified _words_ and
      # within the model.
      #
      def common_ngrams_from_words(words)
        ngrams_from_words(words).select { |ngram| has_ngram?(ngram) }
      end

      #
      # Returns the ngrams which occur within the specified _fragment_ and
      # within the model.
      #
      def common_ngrams_from_fragment(fragment)
        ngrams_from_fragment(fragment).select { |ngram| has_ngram?(ngram) }
      end

      #
      # Returns the ngrams which occur within the specified _sentence_ and
      # within the model.
      #
      def common_ngrams_from_sentence(sentence)
        ngrams_from_sentence(sentence).select { |ngram| has_ngram?(ngram) }
      end

      #
      # Returns the ngrams which occur within the specified _text_ and
      # within the model.
      #
      def common_ngrams_from_text(text)
        ngrams_from_text(text).select { |ngram| has_ngram?(ngram) }
      end

      #
      # Returns the joint probability of the common ngrams between the
      # specified _fragment_ and the model.
      #
      def fragment_commonality(fragment)
        probability_of_ngrams(common_ngrams_from_fragment(fragment))
      end

      #
      # Returns the joint probability of the common ngrams between the
      # specified _sentence_ and the model.
      #
      def sentence_commonality(sentence)
        probability_of_ngrams(common_ngrams_from_sentence(sentence))
      end

      #
      # Returns the joint probability of the common ngrams between the
      # specified _sentence_ and the model.
      #
      def text_commonality(text)
        probability_of_ngrams(common_ngrams_from_text(text))
      end
    end
  end
end
