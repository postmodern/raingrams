require 'raingrams/tokens/token'

module Raingrams
  module Tokens
    class StopSentence < Token

      def initialize
        super('</s>')
      end

    end
  end
end
