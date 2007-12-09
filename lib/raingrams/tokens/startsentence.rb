require 'raingrams/tokens/token'

module Raingrams
  module Tokens
    class StartSentence < Token

      def self.to_s
        '<s>'
      end

    end
  end
end
