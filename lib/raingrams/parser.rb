module Raingrams
  module Parser
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

    #
    # Initializes the parser.
    #
    # _options_ may contain the following keys:
    # <tt>:ignore_case</tt>:: Defaults to +false+.
    # <tt>:ignore_punctuation</tt>:: Defaults to +true+.
    # <tt>:ignore_urls</tt>:: Defaults to +false+.
    # <tt>:ignore_phone_numbers</tt>:: Defaults to +false+.
    #
    def initialize(options={})
      @ignore_case = false
      @ignore_punctuation = true
      @ignore_urls = true
      @ignore_phone_numbers = false
      @ignore_references = false

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

      if options.has_key?(:ignore_references)
        @ignore_references = options[:ignore_references]
      end
    end

    #
    # Parses the specified _sentence_ and returns an Array of tokens.
    #
    def parse_sentence(sentence)
      sentence = sentence.to_s

      if @ignore_punctuation
        # eat tailing punctuation
        sentence.gsub!(/[\.\?!]*$/,'')
      end

      if @ignore_case
        # downcase the sentence
        sentence.downcase!
      end

      if @ignore_urls
        sentence.gsub!(/\s*\w+:\/\/[\w\/\+_\-,:%\d\.\-\?&=]*\s*/,' ')
      end

      if @ignore_phone_numbers
        # remove phone numbers
        sentence.gsub!(/\s*(\d-)?(\d{3}-)?\d{3}-\d{4}\s*/,' ')
      end

      if @ignore_references
        # remove RFC style references
        sentence.gsub!(/\s*[\(\{\[]\d+[\)\}\]]\s*/,' ')
      end

      if @ignore_punctuation
        # split and ignore punctuation characters
        return sentence.scan(/\w+[\-_\.:']\w+|\w+/)
      else
        # split and accept punctuation characters
        return sentence.scan(/[\w\-_,:;\.\?\!'"\\\/]+/)
      end
    end

    #
    # Parses the specified _text_ and returns an Array of sentences.
    #
    def parse_text(text)
      text = text.to_s

      if @ignore_urls
        text.gsub!(/\s*\w+:\/\/[\w\/\+_\-,:%\d\.\-\?&=]*\s*/,' ')
      end

      return text.scan(/[^\s\.\?!][^\.\?!]*[\.\?\!]/)
    end
  end
end
