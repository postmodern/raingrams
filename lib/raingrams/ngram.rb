module Raingrams
  class Ngram < Array

    def initialize(objs)
      super(objs.map { |obj| obj.to_gram })
    end

    def self.[](*objs)
      self.new(objs)
    end

    def prefix
      self[0...length-1]
    end

    def prefixed_by?(ngram)
      prefix==ngram
    end

    def postfix
      self[1..-1]
    end

    def postfixed_by?(ngram)
      postfix==ngram
    end

    def starts_with?(obj)
      self[0]==obj.to_gram
    end

    def ends_with?(obj)
      self[-1]==obj.to_gram
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

  end
end
