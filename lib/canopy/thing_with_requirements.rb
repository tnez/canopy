module Canopy
  class ThingWithRequirements < Canopy::BaseThing
    typed_attr :my_name, String
    typed_attr :my_number, Integer
    validates_presence_of :my_name
  end
end
