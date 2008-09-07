require 'raingrams/ngram_model'

module Raingrams
  class HexagramModel < NgramModel

    def initialize(options={},&block)
      super(options.merge(:ngram_size => 6),&block)
    end

  end
end
