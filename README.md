As required in the exercise, create a generic class that can be used
to create objects with enumerated and typed attributes.

## Installation

```sh
git clone https://github.com/tnez/canopy.git
cd canopy
bundle install
```

## Running Tests

Simply run ```rake``` or ```rake test```.

## Implementation

Implemented a base class with class methods enabling the following
macros intended to be invoked in the any inheriting subclass. After
invoking the macros in the definition of the subclass, values for
attributes can be specified at instantiation by providing a hash, or
by using typical attribute getter / setter syntax.

```ruby
typed_attr :attribute_name, AttributeType
validates_presence_of :attribute_name

```

### BaseThing

```ruby

class BaseThing

    # Generate an attribute for the thing of specified type. After
    # referencing this macro in the child class, said class will have
    # an attribute that can be accessed and be gauranteed to have a
    # given type. This implementation enforces type-checking on the
    # setting of the element and throws an exception if the type is
    # not as specified.
    def self.typed_attr(attr_name, attr_type)
      # define attribute getter using the given name
      define_method attr_name do
        @stored_values[attr_name]
      end
      # define attribute setter using the given name
      define_method "#{attr_name}=" do |new_value|
        # if the value is of the specified type, then go ahead and set
        if new_value.is_a? attr_type
          @stored_values[attr_name] = new_value
        else
          # otherwise, let the user know that something other than the
          # expected type was provided
          raise ArgumentError.new("#{attr_name} expected to be of type: #{attr_type}")
        end
      end
    end

    # Define a default required attributes which returns an empty
    # list. If a subclass does define required attributes using the
    # validates_presence_of macro, we will override this method at
    # parse time to return this, concatenated with whatever else is
    # found
    def self.required_attributes
      @required_attributes ||= []
    end

    # Mark a dynamically generated attribute as required using this
    # macro in the child class. Said class will raise an exception on
    # initialization if attribute is not defined.
    def self.validates_presence_of(attr_names)
      # concatenate old and new required attributes - they may be
      # specified in multiple lines, so this will cause problems if we
      # don't concatenate
      # self.required_attributes += attr_names
      self.required_attributes.push attr_names
    end

    # Given an option hash defaulting to an empty hash if none
    # provided, initialize an instance, while respecting types and
    # validations setup in child class
    def initialize(options = {})
      # check that options include all required values
      self.required_attributes.each do |req_attr|
        if not options.keys.include? req_attr
          raise ArgumentError.new("#{req_attr} is required for initialization")
        end
      end
      # attempt to store all given values
      @stored_values = {}
      options.each do |attr_name, attr_value|
        # we are simply invoking the assignment operator on
        # self.attr_name even thought it looks a little convoluted
        self.method("#{attr_name}=").call(attr_value)
      end
    end

    # Define a method to make it a bit easier to grab the class-level
    # required attributes from an instance. It just looked a bit to
    # awkard writing self.class.required_attributes
    def required_attributes
      self.class.required_attributes
    end
  end
  ```

### Example subclass invoking macros

```ruby
  class ThingWithRequirements < Canopy::BaseThing
    typed_attr :my_name, String
    typed_attr :my_number, Integer
    validates_presence_of :my_name
  end
  ```

### Example testing for simple case

```ruby
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

```
