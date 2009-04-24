require 'raingrams/tokens/start_sentence'
require 'raingrams/tokens/stop_sentence'
require 'raingrams/tokens/unknown'

module Raingrams
  module Tokens
    #
    # Returns all defined tokens.
    #
    def Tokens.all
      @@raingram_tokens ||= {}
    end

    #
    # Returns the start sentence token.
    #
    def Tokens.start
      Tokens.all[:start] ||= StartSentence.new
    end

    #
    # Returns the stop sentence token.
    #
    def Tokens.stop
      Tokens.all[:stop] ||= StopSentence.new
    end

    #
    # Returns the unknown word token.
    #
    def Tokens.unknown
      Tokens.all[:unknown] ||= Unknown.new
    end
  end
end
