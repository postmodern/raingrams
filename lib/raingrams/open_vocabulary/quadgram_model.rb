require 'raingrams/quadgram_model'
require 'raingrams/openvocabulary/open_model'

module Raingrams
  module OpenVocabulary
    class QuadgramModel < Raingrams::QuadgramModel

      include OpenModel

    end
  end
end
