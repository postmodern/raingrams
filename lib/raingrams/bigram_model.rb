require 'raingrams/multigram_model'

module Raingrams
  class BigramModel < MultigramModel

    def initialize(opts={},&block)
      opts[:ngram_size] = 2

      super(opts,&block)
    end

  end
end
