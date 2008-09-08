require 'raingrams/tokens/token'

module Raingrams
  module Tokens
    class StopSentence < Token

      def to_s
        '</s>'
      end

    end
  end
end
