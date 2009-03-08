module Raingrams
  module Helpers
    module Random
      #
      # Returns a random gram from the model.
      #
      def random_gram
        prefix = @prefixes.keys[rand(@prefixes.length)]

        return prefix[rand(prefix.length)]
      end

      #
      # Returns a random ngram from the model.
      #
      def random_ngram
        prefix_index = rand(@prefixes.length)

        prefix = @prefixes.keys[prefix_index]
        table = @prefixes.values[prefix_index]

        gram_index = rand(table.grams.length)

        return (prefix + table.grams[gram_index])
      end

      #
      # Returns a randomly generated sentence of grams using the given
      # _options_.
      #
      def random_gram_sentence(options={})
        grams = []
        last_ngram = @starting_ngram

        loop do
          next_ngrams = ngrams_prefixed_by(last_ngram.postfix).to_a
          last_ngram = next_ngrams[rand(next_ngrams.length)]

          if last_ngram.nil?
            return []
          else
            last_gram = last_ngram.last

            break if last_gram == Tokens.stop

            grams << last_gram
          end
        end

        return grams
      end

      #
      # Returns a randomly generated sentence of text using the given
      # _options_.
      #
      def random_sentence(options={})
        grams = random_gram_sentence(options)
        sentence = grams.delete_if { |gram|
          gram == Tokens.start || gram == Tokens.stop
        }.join(' ')

        if @ignore_case
          sentence.capitalize!
        end

        if @ignore_punctuation
          sentence << '.'
        end

        return sentence
      end

      #
      # Returns a randomly generated paragraph of text using the given
      # _options_.
      #
      # _options_ may contain the following keys:
      # <tt>:min_sentences</tt>:: Minimum number of sentences in the
      #                           paragraph. Defaults to 3.
      # <tt>:max_sentences</tt>:: Maximum number of sentences in the
      #                           paragraph. Defaults to 6.
      #
      def random_paragraph(options={})
        min_sentences = (options[:min_sentences] || 3)
        max_sentences = (options[:max_sentences] || 6)
        sentences = []

        (rand(max_sentences - min_sentences) + min_sentences).times do
          sentences << random_sentence(options)
        end

        return sentences.join(' ')
      end

      #
      # Returns randomly generated text using the given _options_.
      #
      # _options_ may contain the following keys:
      # <tt>:min_sentences</tt>:: Minimum number of sentences in the
      #                           paragraph. Defaults to 3.
      # <tt>:max_sentences</tt>:: Maximum number of sentences in the
      #                           paragraph. Defaults to 6.
      # <tt>:min_paragraphs</tt>:: Minimum number of paragraphs in the text.
      #                            Defaults to 3.
      # <tt>:max_paragraphs</tt>:: Maximum number of paragraphs in the text.
      #                            Defaults to 5.
      #
      def random_text(options={})
        min_paragraphs = (options[:min_paragraphs] || 3)
        max_paragraphs = (options[:max_paragraphs] || 6)
        paragraphs = []

        (rand(max_paragraphs - min_paragraphs) + min_paragraphs).times do
          paragraphs << random_paragraph(options)
        end

        return paragraphs.join("\n\n")
      end
    end
  end
end
