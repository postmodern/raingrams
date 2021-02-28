require 'raingrams/version'

require 'spec_helper'

describe Raingrams do
  it "should have a VERSION constant" do
    expect(Raingrams.const_defined?('VERSION')).to eq(true)
  end
end
