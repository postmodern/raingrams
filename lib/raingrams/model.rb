require 'raingrams/ngram'
require 'raingrams/ngram_set'
require 'raingrams/tokens'
require 'raingrams/probability_table'
require 'raingrams/parser'
require 'raingrams/statistics'

require 'set'

module Raingrams
  class Model

    include Parser
    include Statistics::Frequency
    include Statistics::Probability
    include Statistics::Similarity
    include Statistics::Commonality
    include Statistics::Random

    # Size of ngrams to use
    attr_reader :ngram_size

    # The sentence starting ngram
    attr_reader :starting_ngram

    # The sentence stopping ngram
    attr_reader :stoping_ngram

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
      super(options)

      @ngram_size = options[:ngram_size]
      @starting_ngram = Ngram.new(Tokens.start * @ngram_size)
      @stoping_ngram = Ngram.new(Tokens.stop * @ngram_size)

      @prefixes = {}

      block.call(self) if block
    end

    #
    # Creates a new model object with the given _options_. If a
    # _block_ is given, it will be passed the newly created model. After
    # the block as been called the model will be built.
    #
    def self.build(options={},&block)
      self.new(options) do |model|
        model.build(&block)
      end
    end

    #
    # Creates a new model object with the given _options_ and trains it
    # with the specified _paragraph_.
    #
    def self.train_with_paragraph(paragraph,options={})
      self.build(options) do |model|
        model.train_with_paragraph(paragraph)
      end
    end

    #
    # Creates a new model object with the given _options_ and trains it
    # with the specified _text_.
    #
    def self.train_with_text(text,options={})
      self.build(options) do |model|
        model.train_with_text(text)
      end
    end

    #
    # Creates a new model object with the given _options_ and trains it
    # with the contents of the specified _path_.
    #
    def self.train_with_file(path,options={})
      self.build(options) do |model|
        model.train_with_file(path)
      end
    end

    #
    # Creates a new model object with the given _options_ and trains it
    # with the inner text of the paragraphs tags at the specified _url_.
    #
    def self.train_with_url(url,options={})
      self.build(options) do |model|
        model.train_with_url(url)
      end
    end

    #
    # Marshals a model from the contents of the file at the specified
    # _path_.
    #
    def self.open(path)
      model = nil

      File.open(path) do |file|
        model = Marshal.load(file)
      end

      return model
    end

    #
    # Returns the ngrams that compose the model.
    #
    def ngrams
      ngram_set = NgramSet.new

      @prefixes.each do |prefix,table|
        table.each_gram do |postfix_gram|
          ngram_set << (prefix + postfix_gram)
        end
      end

      return ngram_set
    end

    #
    # Returns +true+ if the model contains the specified _ngram_, returns
    # +false+ otherwise.
    #
    def has_ngram?(ngram)
      if @prefixes.has_key?(ngram.prefix)
        return @prefixes[ngram.prefix].has_gram?(ngram.last)
      else
        return false
      end
    end

    #
    # Iterates over the ngrams that compose the model, passing each one
    # to the given _block_.
    #
    def each_ngram(&block)
      @prefixes.each do |prefix,table|
        table.each_gram do |postfix_gram|
          block.call(prefix + postfix_gram) if block
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

      return selected_ngrams
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
          table.each_gram do |postfix_gram|
            ngram_set << (prefix + postfix_gram)
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
    # Returns the ngrams including any of the specified _grams_.
    #
    def ngrams_including_any(*grams)
      ngram_set = NgramSet.new

      @prefixes.each do |prefix,table|
        if prefix.includes_any?(*grams)
          table.each_gram do |postfix_gram|
            ngram_set << (prefix + postfix_gram)
          end
        else
          table.each_gram do |postfix_gram|
            if grams.include?(postfix_gram)
              ngram_set << (prefix + postfix_gram)
            end
          end
        end
      end

      return ngram_set
    end

    #
    # Returns the ngrams including all of the specified _grams_.
    #
    def ngrams_including_all(*grams)
      ngram_set = NgramSet.new

      each_ngram do |ngram|
        ngram_set << ngram if ngram.includes_all?(*grams)
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

    alias ngrams_from_paragraph ngrams_from_text

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
      @prefixes.keys.inject(Set.new) do |all_grams,gram|
        all_grams + gram
      end
    end

    #
    # Returns +true+ if the model contain the specified _gram_, returns
    # +false+ otherwise.
    #
    def has_gram?(gram)
      @prefixes.keys.any? do |prefix|
        prefix.include?(gram)
      end
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
    # Train the model with the specified _paragraphs_.
    #
    def train_with_paragraph(paragraph)
      train_with_ngrams(ngrams_from_paragraph(paragraph))
    end

    #
    # Train the model with the specified _text_.
    #
    def train_with_text(text)
      train_with_ngrams(ngrams_from_text(text))
    end

    #
    # Train the model with the contents of the specified _path_.
    #
    def train_with_file(path)
      train_with_text(File.read(path))
    end

    #
    # Caclulates the probabilities of the ngrams.
    #
    def calculate!
      @prefixes.each_value { |table| table.build }
      return self
    end

    #
    # Refreshes the probability tables of the model.
    #
    def refresh(&block)
      block.call(self) if block

      return calculate!
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

    #
    # Saves the model to the file at the specified _path_.
    #
    def save(path)
      File.open(path,'w') do |file|
        Marshal.dump(self,file)
      end

      return self
    end

    #
    # Returns a Hash representation of the model.
    #
    def to_hash
      @prefixes
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
