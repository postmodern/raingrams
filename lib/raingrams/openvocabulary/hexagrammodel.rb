require 'raingrams/hexagrammodel'
require 'raingrams/openvocabulary/openmodel'

module Raingrams
  module OpenVocabulary
    class HexagramModel < Raingrams::HexagramModel

      include OpenModel

    end
  end
end
