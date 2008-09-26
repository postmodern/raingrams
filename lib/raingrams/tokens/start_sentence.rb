require 'raingrams/tokens/token'

module Raingrams
  module Tokens
    class StartSentence < Token

      def initialize
        super('<s>')
      end

    end
  end
end
