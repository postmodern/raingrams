module Raingrams
  class ProbabilityTable

    # Indicates wether the table needs to be rebuilt
    attr_reader :dirty

    # Frequencies of grams
    attr_reader :frequencies

    # Probabilities of grams
    attr_reader :probabilities

    #
    # Creates a new empty ProbabilityTable object.
    #
    def initialize
      @dirty = false
      @total = 0
      @frequencies = {}
      @probabilities = {}
    end

    #
    # Returns +true+ if the probability table is dirty and needs to be
    # rebuilt, returns +false+ otherwise.
    #
    def dirty?
      @dirty == true
    end

    #
    # Returns +true+ if the probability table contains the specified _gram_,
    # returns +false+ otherwise.
    #
    def has_gram?(gram)
      @frequencies.has_key?(gram)
    end

    #
    # Returns the grams within the probability table.
    #
    def grams
      @frequencies.keys
    end

    #
    # Iterates over each gram in the probability table, passing each to the
    # given _block_.
    #
    def each_gram(&block)
      @frequencies.each_key(&block)
    end

    #
    # Returns the frequency of the specified _gram_. Returns +0+ by default.
    #
    def frequency_of(gram)
      @frequencies.fetch(gram,0)
    end

    #
    # Returns the probability of the specified _gram_ occurring. Returns
    # <tt>0.0</tt> by default.
    #
    def probability_of(gram)
      @probabilities.fetch(gram,0.0)
    end

    alias [] probability_of

    #
    # Sets the frequency of the specified _gram_ to the specified _value_.
    #
    def set_count(gram,value)
      @dirty = true
      @frequencies[gram] = value
    end

    #
    # Increments the frequency of the specified _gram_ and marks the
    # probability table as dirty.
    #
    def count(gram)
      @dirty = true

      unless @frequencies.has_key?(gram)
        @frequencies[gram] = 0
      end

      return @frequencies[gram] += 1
    end

    #
    # Calculates the total via the summation of the frequencies. Also
    # marks the probability table as dirty.
    #
    def total
      if @dirty
        @total = 0
        @frequencies.each_value { |freq| @total += freq }
      end

      return @total
    end

    #
    # Builds the probability table using the recorded frequencies, if the
    # table is marked as dirty.
    #
    def build
      if @dirty
        current_total = total.to_f

        @frequencies.each do |gram,count|
          @probabilities[gram] = count.to_f / current_total
        end

        @dirty = false
      end

      return self
    end

    #
    # Returns +true+ if the probability table is empty, returns +false+
    # otherwise.
    #
    def empty?
      @total == 0
    end

    #
    # Clears the probability table.
    #
    def clear
      @total = 0
      @frequencies.clear
      @probabilities.clear

      return self
    end

    #
    # Returns a Hash representation of the probability table.
    #
    def to_hash
      build

      return @probabilities
    end

    def inspect
      if @dirty
        "#<#{self.class}: @total=#{@total} @frequencies=#{@frequencies.inspect}>"
      else
        @probabilities.inspect
      end
    end

  end
end
