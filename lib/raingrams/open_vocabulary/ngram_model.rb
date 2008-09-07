require 'raingrams/ngram_model'
require 'raingrams/openvocabulary/open_model'

module Raingrams
  module OpenVocabulary
    class NgramModel < Raingrams::NgramModel

      include OpenModel

    end
  end
end
