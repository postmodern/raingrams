require 'raingrams/unigrammodel'
require 'raingrams/multigrammodel'
require 'raingrams/openvocabulary/unigrammodel'
require 'raingrams/openvocabulary/multigrammodel'

module Raingrams
  def Raingrams.closed_vocabulary_model(opts={},&block)
    if opts[:ngram_size]==1
      return UnigramModel.new(opts,&block)
    else
      return MultigramModel.new(opts,&block)
    end
  end

  def Raingrams.open_vocabulary_model(opts={},&block)
    if opts[:ngram_size]==1
      return OpenVocabulary::UnigramModel.new(opts,&block)
    else
      return OpenVocabulary::MultigramModel.new(opts,&block)
    end
  end

  def Raingrams.model(opts={},&block)
    case opts[:vocabulary]
    when :open, 'open'
      return Raingrams.open_vocabulary_model(opts,&block)
    else
      return Raingrams.closed_vocabulary_model(opts,&block)
    end
  end
end
