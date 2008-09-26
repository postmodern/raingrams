module Raingrams
  module Tokens
    class Token

      # Gram form of the token
      attr_reader :gram

      #
      # Creates a new Token object with the specified _gram_.
      #
      def initialize(gram)
        @gram = gram
      end

      def to_gram
        self
      end

      #
      # Creates an Array of the specified _length_ containing the token.
      #
      def *(length)
        [self] * length
      end

      #
      # Returns +true+ if the token has the same gram as the _other_ token,
      # returns +false+ otherwise.
      #
      def eql?(other)
        if other.kind_of?(Token)
          return (@gram == other.gram)
        end

        return false
      end

      alias == eql?

      #
      # Returns the String form of the token.
      #
      def to_s
        @gram.to_s
      end

      #
      # Returns the Symbol form of the token.
      #
      def to_sym
        @gram.to_sym
      end

      #
      # Returns the String form of the token.
      #
      def inspect
        @gram.to_s
      end

    end
  end
end
