module Canopy
  class ThingWithComplexObject < Canopy::BaseThing
    typed_attr :my_name, String
    typed_attr :my_number, Integer
    typed_attr :my_complex_object, Canopy::Foo
  end
end
