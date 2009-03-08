require 'raingrams/helpers/probability'

module Raingrams
  module Helpers
    module Commonality
      def self.included(base)
        base.module_eval { include Raingrams::Helpers::Probability }
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
