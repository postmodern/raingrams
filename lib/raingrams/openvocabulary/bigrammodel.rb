require 'raingrams/bigrammodel'
require 'raingrams/openvocabulary/openmodel'

module Raingrams
  module OpenVocabulary
    class BigramModel < Raingrams::BigramModel

      include OpenModel

    end
  end
end
