require 'raingrams/ngram_model'

module Raingrams
  class BigramModel < NgramModel

    def initialize(options={},&block)
      super(options.merge(:ngram_size => 2),&block)
    end

  end
end
