module Raingrams
  module Tokens
    class Token

      def self.*(length)
        self.new * length
      end

      def *(length)
        [self] * length
      end

      def to_sym
        to_s.to_sym
      end

      def inspect
        to_s
      end

    end
  end
end
