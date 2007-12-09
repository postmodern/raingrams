require 'raingrams/multigrammodel'
require 'raingrams/openvocabulary/openmodel'

module Raingrams
  module OpenVocabulary
    class MultigramModel < Raingrams::MultigramModel

      include OpenModel

    end
  end
end
