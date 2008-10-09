require 'raingrams/trigram_model'

require 'spec_helper'
require 'model_examples'

describe TrigramModel do
  before(:all) do
    @model = TrigramModel.build do |model|
      model.train_with_text(Training.text_for(:snowcrash))
    end
  end

  it_should_behave_like "Model"
end
