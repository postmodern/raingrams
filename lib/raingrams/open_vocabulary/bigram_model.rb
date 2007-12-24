require 'raingrams/bigram_model'
require 'raingrams/openvocabulary/open_model'

module Raingrams
  module OpenVocabulary
    class BigramModel < Raingrams::BigramModel

      include OpenModel

    end
  end
end
