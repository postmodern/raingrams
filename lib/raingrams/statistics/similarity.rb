require 'raingrams/statistics/commonality'

module Raingrams
  module Statistics
    module Similarity
      include Commonality

      #
      # Returns the conditional probability of the commonality of the
      # specified _fragment_ against the _other_model_, given the
      # commonality of the _fragment_ against the model.
      #
      def fragment_similarity(fragment,other_model)
        other_model.fragment_commonality(fragment) / fragment_commonality(fragment)
      end

      #
      # Returns the conditional probability of the commonality of the
      # specified _sentence_ against the _other_model_, given the
      # commonality of the _sentence_ against the model.
      #
      def sentence_similarity(sentence,other_model)
        other_model.sentence_commonality(sentence) / sentence_commonality(sentence)
      end

      #
      # Returns the conditional probability of the commonality of the
      # specified _text_ against the _other_model_, given the commonality
      # of the _text_ against the model.
      #
      def text_similarity(text,other_model)
        other_model.text_commonality(text) / text_commonality(text)
      end
    end
  end
end
