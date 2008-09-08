require 'raingrams/unigram_model'
require 'raingrams/open_vocabulary/open_model'

module Raingrams
  module OpenVocabulary
    class UnigramModel < Raingrams::UnigramModel

      include OpenModel

    end
  end
end
