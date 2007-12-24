require 'raingrams/unigram_model'
require 'raingrams/openvocabulary/open_model'

module Raingrams
  module OpenVocabulary
    class UnigramModel < Raingrams::UnigramModel

      include OpenModel

    end
  end
end
