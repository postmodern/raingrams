require 'raingrams/trigrammodel'
require 'raingrams/openvocabulary/openmodel'

module Raingrams
  module OpenVocabulary
    class TrigramModel < Raingrams::TrigramModel

      include OpenModel

    end
  end
end
