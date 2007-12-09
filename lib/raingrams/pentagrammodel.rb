require 'raingrams/multigrammodel'

module Raingrams
  class PentagramModel < MultigramModel

    def initialize(opts={},&block)
      opts[:ngram_size] = 5

      super(opts,&block)
    end

  end
end
