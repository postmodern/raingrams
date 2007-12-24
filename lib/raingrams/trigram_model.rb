require 'raingrams/multigram_model'

module Raingrams
  class TrigramModel < MultigramModel

    def initialize(opts={},&block)
      opts[:ngram_size] = 3

      super(opts,&block)
    end

  end
end
