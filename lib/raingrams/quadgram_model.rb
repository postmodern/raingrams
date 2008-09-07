require 'raingrams/ngram_model'

module Raingrams
  class QuadgramModel < NgramModel

    def initialize(options={},&block)
      super(options.merge(:ngram_size => 4),&block)
    end

  end
end
