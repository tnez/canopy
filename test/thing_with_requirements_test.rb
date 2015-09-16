require 'test_helper'

# Thing With Requirements is a subclass defined similarly to Simple
# Thing, but with the addition of a simple requirment spec.
# 
#   class ThingWithRequirements < Canopy::BaseThing
#     typed_attr :my_name, String
#     typed_attr :my_number, Integer
#     validates_presence_of :my_name
#   end

describe Canopy::ThingWithRequirements do

  describe "handling of instantiation" do
    it "throws an exception when required attribute not included" do
      proc { Canopy::ThingWithRequirements.new }.must_raise ArgumentError
    end
  end
end
