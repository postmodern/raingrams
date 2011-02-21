require 'raingrams/extensions'

module Raingrams
  class Ngram < Array

    #
    # Creates a new Ngram object with the specified _objects_.
    #
    def initialize(objects=nil)
      if objects
        super(objects.map { |obj| obj.to_gram })
      else
        super()
      end
    end

    #
    # Creates a new Ngram object from the specified _objects_.
    #
    def self.[](*objects)
      self.new(objects)
    end

    #
    # Creates a new Ngram object by appending the specified _grams_ to the
    # ngram.
    #
    def +(grams)
      grams = if grams.kind_of?(Enumerable)
                grams.map { |gram| gram.to_gram }
              else
                [grams.to_gram]
              end

      return self.class.new(super(grams))
    end

    def <<(gram)
      super(gram.to_gram)
    end

    #
    # Returns the prefix of the ngram.
    #
    def prefix
      self[0...length-1]
    end

    #
    # Returns +true+ if the ngram is prefixed by the specified
    # _smaller_ngram_.
    #
    def prefixed_by?(smaller_ngram)
      prefix == smaller_ngram
    end

    def postfix
      self[1..-1]
    end

    def postfixed_by?(ngram)
      postfix == ngram
    end

    def starts_with?(obj)
      first == obj.to_gram
    end

    def ends_with?(obj)
      last == obj.to_gram
    end

    def include?(obj)
      super(obj.to_gram)
    end

    def includes_any?(*grams)
      grams.any? { |gram| include?(gram) }
    end

    def includes_all?(*grams)
      grams.all? { |gram| include?(gram) }
    end

    alias flatten dup

    def flatten!
      self
    end

    def to_s
      join(', ')
    end

    def inspect
      'Ngram[' + map { |gram| gram.inspect }.join(', ') + ']'
    end

  end
end
