require 'raingrams/trigram_model'
require 'raingrams/openvocabulary/open_model'

module Raingrams
  module OpenVocabulary
    class TrigramModel < Raingrams::TrigramModel

      include OpenModel

    end
  end
end
