require 'raingrams/tokens/token'

module Raingrams
  module Tokens
    class Unknown < Token

      def self.to_s
        '<unknown>'
      end

    end
  end
end
