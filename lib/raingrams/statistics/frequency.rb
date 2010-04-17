module Raingrams
  module Statistics
    module Frequency
      #
      # Returns the observed frequency of the specified _ngram_ within
      # the training text.
      #
      def frequency_of_ngram(ngram)
        prefix = ngram.prefix

        if @prefixes.has_key?(prefix)
          return @prefixes[prefix].frequency_of(ngram.last)
        else
          return 0
        end
      end

      #
      # Returns the observed frequency of the specified _ngrams_ occurring
      # within the training text.
      #
      def frequencies_for(ngrams)
        table = {}

        ngrams.each do |ngram|
          table[ngram] = frequency_of_ngram(ngram)
        end

        return table
      end

      #
      # Returns the total observed frequency of the specified _ngrams_
      # occurring within the training text.
      #
      def frequency_of_ngrams(ngrams)
        frequencies_for(ngrams).values.inject(0) do |total,freq|
          total + freq
        end
      end
    end
  end
end
