require 'test_helper'

# Thing With Complex Object is a subclass that includes a user defined
# class as one of its types.
#
#   class ThingWithComplexObject < Canopy::BaseThing
#     typed_attr :my_name, String
#     typed_attr :my_number, Integer
#     typed_attr :my_complex_object, Canopy::Foo
#   end

describe Canopy::ThingWithComplexObject do
  before do
    @foo = Canopy::Foo.new
  end

  describe "setting during instantiation" do
    it "should accept an instance of a user defined object" do
      @thing = Canopy::ThingWithComplexObject.new(my_complex_object: @foo)
      @thing.my_complex_object.must_be_instance_of Canopy::Foo
    end
    it "should raise an exception if not of expected type" do
      proc { Canopy::ThingWithComplexObject.new(my_complex_object: "foo") }.must_raise ArgumentError
    end
  end

  describe "setting after instantiation" do
    it "should accept an instance of a user defined object" do
      @thing = Canopy::ThingWithComplexObject.new
      @thing.my_complex_object = @foo
      @thing.my_complex_object.must_be_instance_of Canopy::Foo
    end
    it "should raise an exception if not of expected type" do
      @thing = Canopy::ThingWithComplexObject.new
      proc { @thing.my_complex_object = "foo" }.must_raise ArgumentError
    end
    
  end
end
