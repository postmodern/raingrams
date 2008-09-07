require 'raingrams/ngram_model'

module Raingrams
  class PentagramModel < NgramModel

    def initialize(options={},&block)
      super(options.merge(:ngram_size => 5),&block)
    end

  end
end
