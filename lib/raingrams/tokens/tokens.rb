require 'raingrams/tokens/start_sentence'
require 'raingrams/tokens/stop_sentence'
require 'raingrams/tokens/unknown'

module Raingrams
  module Tokens
    def Tokens.all
      @@raingram_tokens ||= {}
    end

    def Tokens.start
      Tokens.all[:start] ||= StartSentence.new
    end

    def Tokens.stop
      Tokens.all[:stop] ||= StopSentence.new
    end

    def Tokens.unknown
      Tokens.all[:unknown] ||= Unknown.new
    end
  end
end
