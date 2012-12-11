class DynamicSlotObject : Fancy BasicObject {
  """
  Helper class to dynamically create @Object@s with slots defined by sending messages to it.

  Example:
        dso = DynamicSlotObject new
        dso name: \"Chris\"
        dso age: 25
        dso country: \"Germany\"

        dso object  # => Object with slots 'name, 'age and 'country defined
  """

  def initialize {
    @object = Object new
  }

  def object {
    """
    @return @Object@ with slots defined dynamically by sending messages to @self.
    """

    @object metaclass read_write_slots: (@object slots)
    @object
  }

  def unknown_message: m with_params: p {
    m to_s split: ":" . each_with_index: |slotname idx| {
      @object set_slot: slotname value: $ p[idx]
    }
  }
}

class DynamicKeyHash : Fancy BasicObject {
  """
  Helper class to dynamically create @Hash@es with keys and values defined by sending messages to it.

  Example:
        dkh = DynamicKeyHash new
        dkh name: \"Chris\"
        dkh age: 25
        dkh country: \"Germany\"

        dkh hash  # => <['name => \"Chris\", 'age => 25, 'country => \"Germany\"]>
  """

  def initialize: @deep (false) {
    """
    @deep If @true, recursively sends @to_hash to any value passed as an argument to @self that is a @Block@ (dynamically creating nested @Hash@es).
    """

    @hash = <[]>
  }

  def hash {
    """
    @return @Hash@ generated dynamically by sending messages to @self.
    """

    @hash
  }

  def unknown_message: m with_params: p {
    m to_s split: ":" . each_with_index: |slotname idx| {
      val = p[idx]
      if: @deep then: {
        match val {
          case Block -> val = val to_hash_deep
        }
      }
      @hash[slotname to_sym]: val
    }
  }
}

class DynamicValueArray : Fancy BasicObject {
  """
  Helper class to dynamically create @Array@s with values defined by sending messages to it.

  Example:
        dva = DynamicValueArray new
        dva name: \"Chris\"
        dva age: 25
        dva country: \"Germany\"
        dva something_else

        dva array  # => [['name, \"Chris\"], ['age, 25], ['country, \"Germany\"], 'something_else]
  """

  def initialize {
    @arr = []
  }

  def array {
    """
    @return @Array@ generated dynamically by sending messages to @self.
    """

    @arr
  }

  def unknown_message: m with_params: p {
    if: (p size > 0) then: {
      subarr = []
      m to_s split: ":" . each_with_index: |slotname idx| {
        subarr << (slotname to_sym)
        subarr << (p[idx])
      }
      @arr << subarr
    } else: {
      @arr << (m to_s rest to_sym) # skip leading :
    }
    self
  }
}
