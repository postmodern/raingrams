require 'raingrams/ngram_model'
require 'raingrams/open_vocabulary/open_model'

module Raingrams
  module OpenVocabulary
    class NgramModel < Raingrams::NgramModel

      include OpenModel

    end
  end
end
