require 'raingrams/quadgrammodel'
require 'raingrams/openvocabulary/openmodel'

module Raingrams
  module OpenVocabulary
    class QuadgramModel < Raingrams::QuadgramModel

      include OpenModel

    end
  end
end
