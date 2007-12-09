module Raingrams
  module Tokens
    class Token

      def self.*(length)
        [self] * length
      end

      def self.to_sym
        self.to_s.to_sym
      end

      def self.inspect
        self.to_s
      end

    end
  end
end
