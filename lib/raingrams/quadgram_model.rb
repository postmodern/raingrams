require 'raingrams/multigram_model'

module Raingrams
  class QuadgramModel < MultigramModel

    def initialize(opts={},&block)
      opts[:ngram_size] = 4

      super(opts,&block)
    end

  end
end
