require 'raingrams/ngram_model'

module Raingrams
  class TrigramModel < NgramModel

    def initialize(options={},&block)
      super(options.merge(:ngram_size => 3),&block)
    end

  end
end
