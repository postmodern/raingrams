require 'raingrams/ngram'
require 'raingrams/ngram_set'
require 'raingrams/probability_table'
require 'raingrams/tokens'

require 'set'

module Raingrams
  class Model

    # Size of ngrams to use
    attr_reader :ngram_size

    # The sentence starting ngram
    attr_reader :starting_ngram

    # The sentence stopping ngram
    attr_reader :stoping_ngram

    # Ignore case of parsed text
    attr_reader :ignore_case

    # Ignore the punctuation of parsed text
    attr_reader :ignore_punctuation

    # Ignore URLs
    attr_reader :ignore_urls

    # Ignore Phone numbers
    attr_reader :ignore_phone_numbers

    # Ignore References
    attr_reader :ignore_references

    # Probabilities of all (n-1) grams
    attr_reader :prefixes

    #
    # Creates a new NgramModel with the specified _options_.
    #
    # _options_ must contain the following keys:
    # <tt>:ngram_size</tt>:: The size of each gram.
    #
    # _options_ may contain the following keys:
    # <tt>:ignore_case</tt>:: Defaults to +false+.
    # <tt>:ignore_punctuation</tt>:: Defaults to +true+.
    # <tt>:ignore_urls</tt>:: Defaults to +false+.
    # <tt>:ignore_phone_numbers</tt>:: Defaults to +false+.
    #
    def initialize(options={},&block)
      @ngram_size = options[:ngram_size]
      @starting_ngram = Ngram.new(Tokens.start * @ngram_size)
      @stoping_ngram = Ngram.new(Tokens.stop * @ngram_size)

      @ignore_case = false
      @ignore_punctuation = true
      @ignore_urls = true
      @ignore_phone_numbers = false

      if options.has_key?(:ignore_case)
        @ignore_case = options[:ignore_case]
      end

      if options.has_key?(:ignore_punctuation)
        @ignore_punctuation = options[:ignore_punctuation]
      end

      if options.has_key?(:ignore_urls)
        @ignore_urls = options[:ignore_urls]
      end

      if options.has_key?(:ignore_phone_numbers)
        @ignore_phone_numbers = options[:ignore_phone_numbers]
      end

      @prefixes = {}

      block.call(self) if block
    end

    #
    # Creates a new NgramModel object with the given _options_. If a
    # _block_ is given, it will be passed the newly created model.
    #
    def self.build(options={},&block)
      self.new(options) do |model|
        model.build(&block)
      end
    end

    #
    # Parses the specified _sentence_ and returns an Array of tokens.
    #
    def parse_sentence(sentence)
      # eat tailing punctuation
      sentence = sentence.to_s.gsub(/[\.\?!]$/,'')

      if @ignore_urls
        # remove URLs
        sentence.gsub!(/\s*\w+:\/\/[\w\/,\._\-%\?&=]*\s*/,' ')
      end

      if @ignore_phone_numbers
        # remove phone numbers
        sentence.gsub!(/\s*(\d-)?(\d{3}-)?\d{3}-\d{4}\s*/,' ')
      end

      if @ignore_references
        # remove RFC style references
        sentence.gsub!(/\s*\[\d+\]\s*/,' ')
      end

      if @ignore_case
        # downcase the sentence
        sentence.downcase!
      end

      if @ignore_punctuation
        # split and ignore punctuation characters
        return sentence.scan(/\w+[_\.:']?\w+/)
      else
        # split and accept punctuation characters
        return sentence.scan(/[\w\-_,\.;'"\\\/]+/)
      end
    end

    #
    # Parses the specified _text_ and returns an Array of sentences.
    #
    def parse_text(text)
      text.to_s.scan(/[^\s\.\?!][^\.\?!]*/)
    end

    #
    # Returns the ngrams that compose the model.
    #
    def ngrams
      ngram_set = NgramSet.new

      @prefixes.each do |prefix,table|
        table.each_gram do |gram|
          ngram_set << (prefix + gram)
        end
      end

      return ngram_set
    end

    #
    # Returns +true+ if the model contains the specified _ngram_, returns
    # +false+ otherwise.
    #
    def has_ngram?(ngram)
      @prefixes[ngram.prefix].has_gram?(ngram.last)
    end

    #
    # Iterates over the ngrams that compose the model, passing each one
    # to the given _block_.
    #
    def each_ngram(&block)
      @prefixes.each do |prefix,table|
        table.each_gram do |gram|
          block.call(prefix + gram) if block
        end
      end

      return self
    end

    #
    # Selects the ngrams that match the given _block_.
    #
    def ngrams_with(&block)
      selected_ngrams = NgramSet.new

      each_ngram do |ngram|
        selected_ngrams << ngram if block.call(ngram)
      end

      return ngrams
    end

    #
    # Returns the ngrams prefixed by the specified _prefix_.
    #
    def ngrams_prefixed_by(prefix)
      ngram_set = NgramSet.new

      return ngram_set unless @prefixes.has_key?(prefix)

      ngram_set += @prefixes[prefix].grams.map do |gram|
        prefix + gram
      end

      return ngram_set
    end

    #
    # Returns the ngrams postfixed by the specified _postfix_.
    #
    def ngrams_postfixed_by(postfix)
      ngram_set = NgramSet.new

      @prefixes.each do |prefix,table|
        if prefix[1..-1] == postfix[0..-2]
          if table.has_gram?(postfix.last)
            ngram_set << (prefix + postfix.last)
          end
        end
      end

      return ngram_set
    end

    #
    # Returns the ngrams starting with the specified _gram_.
    #
    def ngrams_starting_with(gram)
      ngram_set = NgramSet.new

      @prefixes.each do |prefix,table|
        if prefix.first == gram
          table.each_gram do |gram|
            ngram_set << (prefix + gram)
          end
        end
      end

      return ngram_set
    end

    #
    # Returns the ngrams which end with the specified _gram_.
    #
    def ngrams_ending_with(gram)
      ngram_set = NgramSet.new

      @prefixes.each do |prefix,table|
        if table.has_gram?(gram)
          ngram_set << (prefix + gram)
        end
      end

      return ngram_set
    end

    #
    # Returns the ngrams including the specified _grams_.
    #
    def ngrams_including(*grams)
      ngram_set = NgramSet.new

      @prefixes.each do |prefix,table|
        if prefix.includes?(grams)
          table.each_gram do |gram|
            ngram_set << (prefix + gram)
          end
        else
          table.each_gram do |gram|
            if grams.include?(gram)
              ngram_set << (prefix + gram)
            end
          end
        end
      end

      return ngram_set
    end

    #
    # Returns the ngrams extracted from the specified _words_.
    #
    def ngrams_from_words(words)
      return (0...(words.length-@ngram_size+1)).map do |index|
        Ngram.new(words[index,@ngram_size])
      end
    end

    #
    # Returns the ngrams extracted from the specified _fragment_ of text.
    #
    def ngrams_from_fragment(fragment)
      ngrams_from_words(parse_sentence(fragment))
    end

    #
    # Returns the ngrams extracted from the specified _sentence_.
    #
    def ngrams_from_sentence(sentence)
      ngrams_from_words(wrap_sentence(parse_sentence(sentence)))
    end

    #
    # Returns the ngrams extracted from the specified _text_.
    #
    def ngrams_from_text(text)
      parse_text(text).inject([]) do |ngrams,sentence|
        ngrams + ngrams_from_sentence(sentence)
      end
    end

    #
    # Returns all ngrams which preceed the specified _gram_.
    #
    def ngrams_preceeding(gram)
      ngram_set = NgramSet.new

      ngrams_ending_with(gram).each do |ends_with|
        ngrams_postfixed_by(ends_with.prefix).each do |ngram|
          ngram_set << ngram
        end
      end

      return ngram_set
    end

    #
    # Returns all ngrams which occur directly after the specified _gram_.
    #
    def ngrams_following(gram)
      ngram_set = NgramSet.new

      ngrams_starting_with(gram).each do |starts_with|
        ngrams_prefixed_by(starts_with.postfix).each do |ngram|
          ngram_set << ngram
        end
      end

      return ngram_set
    end

    #
    # Returns all grams within the model.
    #
    def grams
      @prefixes.keys.flatten.uniq
    end

    #
    # Returns all grams which preceed the specified _gram_.
    #
    def grams_preceeding(gram)
      gram_set = Set.new

      ngrams_ending_with(gram).each do |ngram|
        gram_set << ngram[-2]
      end

      return gram_set
    end

    #
    # Returns all grams which occur directly after the specified _gram_.
    #
    def grams_following(gram)
      gram_set = Set.new

      ngram_starting_with(gram).each do |ngram|
        gram_set << ngram[1]
      end

      return gram_set
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
      ngrams_from_fragment(words).select { |ngram| has_ngram?(ngram) }
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
    # Sets the frequency of the specified _ngram_ to the specified _value_.
    #
    def set_ngram_frequency(ngram,value)
      probability_table(ngram).set_count(ngram.last,value)
    end

    #
    # Train the model with the specified _ngram_.
    #
    def train_with_ngram(ngram)
      probability_table(ngram).count(ngram.last)
    end

    #
    # Train the model with the specified _ngrams_.
    #
    def train_with_ngrams(ngrams)
      ngrams.each { |ngram| train_with_ngram(ngram) }
    end

    #
    # Train the model with the specified _sentence_.
    #
    def train_with_sentence(sentence)
      train_with_ngrams(ngrams_from_sentence(sentence))
    end

    #
    # Train the model with the specified _text_.
    #
    def train_with_text(text)
      train_with_ngrams(ngrams_from_text(text))
    end

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
    # Returns the probably of the specified _gram_ occurring within
    # arbitrary text.
    #
    def probability_of_gram(gram)
      probability_of_ngrams(ngrams_starting_with(gram))
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

    #
    # Returns the conditional probability of the commonality of the
    # specified _fragment_ against the _other_model_, given the commonality
    # of the _fragment_ against the model.
    #
    def fragment_similarity(fragment,other_model)
      other_model.fragment_commonality(fragment) / fragment_commonality(fragment)
    end

    #
    # Returns the conditional probability of the commonality of the
    # specified _sentence_ against the _other_model_, given the commonality
    # of the _sentence_ against the model.
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
      
      # prime the grams
      grams += @starting_ngram

      loop do
        next_ngrams = ngrams_prefixed_by(last_ngram.postfix).to_a
        last_ngram = next_ngrams[rand(next_ngrams.length)]

        if last_ngram.nil?
          return []
        else
          grams << last_ngram.last
          break if last_ngram == @stoping_ngram
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

      sentence << '.' if @ignore_punctuation
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

    #
    # Refreshes the probability tables of the model.
    #
    def refresh(&block)
      block.call(self) if block

      @prefixes.each_value { |table| table.build }
      return self
    end

    #
    # Clears and rebuilds the model.
    #
    def build(&block)
      refresh do
        clear

        block.call(self) if block
      end
    end

    #
    # Clears the model of any training data.
    #
    def clear
      @prefixes.clear
      return self
    end

    protected

    #
    # Defines the default ngram _size_ for the model.
    #
    def self.ngram_size(size)
      class_eval %{
        def initialize(options={},&block)
          super(options.merge(:ngram_size => #{size.to_i}),&block)
        end
      }
    end

    #
    # Wraps the specified _setence_ with StartSentence and StopSentence
    # tokens.
    #
    def wrap_sentence(sentence)
      @starting_ngram + sentence.to_a + @stoping_ngram
    end

    #
    # Returns the probability table for the specified _ngram_.
    #
    def probability_table(ngram)
      @prefixes[ngram.prefix] ||= ProbabilityTable.new
    end

  end
end
