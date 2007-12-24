require 'raingrams/tokens/unknown'

module Raingrams
  module OpenVocabulary
    module OpenModel

      # The fixed lexicon of this model
      attr_reader :lexicon

      def initialize(opts={},&block)
        @lexicon = opts[:lexicon] || []

        super(opts,&block)
      end

      def within_lexicon?(gram)
        @lexicon.include?(gram)
      end

      def train_ngram(ngram)
        ngram = ngram.map do |gram|
          if within_lexicon?(gram)
            gram
          else
            Tokens::Unknown
          end
        end

        return super(ngram)
      end

    end
  end
end
