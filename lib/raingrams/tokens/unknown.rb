require 'raingrams/tokens/token'

module Raingrams
  module Tokens
    class Unknown < Token

      def to_s
        '<unknown>'
      end

    end
  end
end
