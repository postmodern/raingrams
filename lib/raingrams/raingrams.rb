require 'raingrams/unigram_model'
require 'raingrams/ngram_model'
require 'raingrams/open_vocabulary/unigram_model'
require 'raingrams/open_vocabulary/ngram_model'

module Raingrams
  def Raingrams.closed_vocabulary_model(options={},&block)
    if options[:ngram_size] == 1
      return UnigramModel.new(options,&block)
    else
      return NgramModel.new(options,&block)
    end
  end

  def Raingrams.open_vocabulary_model(options={},&block)
    if options[:ngram_size]==1
      return OpenVocabulary::UnigramModel.new(options,&block)
    else
      return OpenVocabulary::NgramModel.new(options,&block)
    end
  end

  def Raingrams.model(options={},&block)
    case options[:vocabulary]
    when :open, 'open'
      return Raingrams.open_vocabulary_model(options,&block)
    else
      return Raingrams.closed_vocabulary_model(options,&block)
    end
  end
end
