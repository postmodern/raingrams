require 'raingrams/version'

require 'spec_helper'

describe Raingrams do
  it "should have a VERSION constant" do
    Raingrams.const_defined?('VERSION').should == true
  end
end
