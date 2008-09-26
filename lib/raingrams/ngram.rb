require 'raingrams/extensions'

module Raingrams
  class Ngram < Array

    #
    # Creates a new Ngram object with the specified _objects_.
    #
    def initialize(objects)
      super(objects.map { |obj| obj.to_gram })
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
      if grams.kind_of?(Array)
        return self.class.new(super(grams.map { |gram|
          gram.to_gram
        }))
      else
        return self.class.new(super([grams.to_gram]))
      end
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
      self.first == obj.to_gram
    end

    def ends_with?(obj)
      self.last == obj.to_gram
    end

    def include?(obj)
      super(obj.to_gram)
    end

    def flatten
      self.dup
    end

    def flatten!
      self
    end

    def to_s
      join(', ')
    end

    def inspect
      'Ngram[' + self.map { |gram| gram.inspect }.join(', ') + ']'
    end

  end
end
