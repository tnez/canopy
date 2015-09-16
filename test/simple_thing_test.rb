require 'test_helper'

# A Simple Thing is a subclass defined in the same way as the example
# in the gist, specifying one string and one integer attribute neither
# one of them required.
#
#    class SimpleThing < Canopy::BaseThing
#      typed_attr :my_name, String
#      typed_attr :my_number, Integer
#    end

describe Canopy::SimpleThing do
  before do
    @simple = Canopy::SimpleThing.new
  end
  
  describe "responds to specified attributes" do
    it "must respond to :my_name" do
      (@simple.respond_to? :my_name).must_equal true
    end
    it "must respond to :my_number" do
      (@simple.respond_to? :my_number).must_equal true
    end
  end

  describe "setting attributes during instantiation" do
    it "has correct values given they are provided during instantiation" do
      @simple = Canopy::SimpleThing.new( my_name: "Travis", my_number: 7 )
      @simple.my_name.must_equal "Travis"
      (@simple.my_name.is_a? String).must_equal true
      @simple.my_number.must_equal 7
      (@simple.my_number.is_a? Integer).must_equal true
    end
  end

  describe "setting attributes after instantiation" do
    it "can set value for my_name and it will be a String" do
      @simple.my_name = "Travis"
      @simple.my_name.must_equal "Travis"
      (@simple.my_name.is_a? String).must_equal true
    end
    it "can set value for my_number and it will be an Integer" do
      @simple.my_number = 7
      @simple.my_number.must_equal 7
      (@simple.my_number.is_a? Integer).must_equal true
    end
    it "raises an exception when setting invalid type" do
      proc { @simple.my_name = 1234 }.must_raise ArgumentError
    end
  end
end
