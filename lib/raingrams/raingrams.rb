require 'raingrams/model'
require 'raingrams/open_vocabulary/model'

module Raingrams
  def Raingrams.closed_vocabulary_model(options={},&block)
    Model.new(options,&block)
  end

  def Raingrams.open_vocabulary_model(options={},&block)
    OpenVocabulary::Model.new(options,&block)
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
