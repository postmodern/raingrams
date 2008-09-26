require 'raingrams/tokens/token'

module Raingrams
  module Tokens
    class Unknown < Token

      def initialize
        super('<unknown>')
      end

    end
  end
end
