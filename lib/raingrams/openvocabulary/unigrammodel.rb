require 'raingrams/unigrammodel'
require 'raingrams/openvocabulary/openmodel'

module Raingrams
  module OpenVocabulary
    class UnigramModel < Raingrams::UnigramModel

      include OpenModel

    end
  end
end
