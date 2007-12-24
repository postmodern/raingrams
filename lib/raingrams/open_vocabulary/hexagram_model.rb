require 'raingrams/hexagram_model'
require 'raingrams/openvocabulary/open_model'

module Raingrams
  module OpenVocabulary
    class HexagramModel < Raingrams::HexagramModel

      include OpenModel

    end
  end
end
