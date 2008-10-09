require 'raingrams/ngram'

require 'set'

module Raingrams
  class NgramSet < Set

    def select(&block)
      selected_ngrams = self.class.new

      each do |ngram|
        selected_ngrams << ngram if block.call(ngram)
      end

      return selected_ngrams
    end

    def prefixed_by(prefix)
      select { |ngram| ngram.prefixed_by?(prefix) }
    end

    def postfixed_by(postfix)
      select { |ngram| ngram.postfixed_by?(postfix) }
    end

    def starts_with(gram)
      select { |ngram| ngram.starts_with?(gram) }
    end

    def ends_with(gram)
      select { |ngram| ngram.ends_with?(gram) }
    end

    def including(gram)
      select { |ngram| ngram.include?(gram) }
    end

    def including_any(*grams)
      select { |ngram| ngram.includes_any?(*grams) }
    end

    def including_all(*grams)
      select { |ngram| ngram.includes_all?(*grams) }
    end

  end
end
