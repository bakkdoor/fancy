class Hash {
  """
  Class for Hashes (HashMaps / Dictionaries).
  Maps a key to a value.
  """

  include: Fancy Enumerable

  alias_method: 'get_slot: for: 'at:
  alias_method: 'set_slot:value: for: 'at:put:

  def [key] {
    """
    @key Key for value to get.
    @return Value for given @key or @nil, if @key not set.

    Returns the value for a given key.
    """

    at: key
  }

  def at: key else: else_block {
    """
    @key Key of the value to get.
    @else_block @Block@ to be called if @key is not found.
    @return Value for @key or value of calling @else_block, if @key is not found.

    Returns the value for a given key.
    If the key is not found, calls @else_block and returns the value it yields.

    Example:
          <['foo => 'bar]> at: 'foo else: { 42 } # => 'bar
          <['foo => 'bar]> at: 'unknown else: { 42 } # => 42
          <['nil => nil]> at: 'nil else: { 'not_found } # => nil
    """

    if: (includes?: key) then: {
      at: key
    } else: {
      else_block call: [key]
    }
  }

  alias_method: 'fetch:else: for: 'at:else:

  def at: key else_put: else_block {
    """
    @key Key of value to get.
    @else_block @Block@ that gets called and its value inserted into @self if @key not in @self.

    Example:
          h = <['foo => 'bar]>
          h at: 'foo else_put: { 42 } # => 'bar
          h['foo] # => 'bar
          h at: 'undefined else_put: { 42 } # => 42
          h['undefined] # => 42
    """

    if: (includes?: key) then: {
      at: key
    } else: {
      at: key put: $ else_block call: [key]
    }
  }

  alias_method: 'fetch:else_put: for: 'at:else_put:

  def each: block {
    """
    @block @Block@ to be called with each key and value in @self.
    @return @self
    Calls a given @Block@ with each key and value.
    """

    if: (block arity == 1) then: {
      keys each: |key| {
        block call: [[key, at: key]]
      }
    } else: {
      keys each: |key| {
        block call: [key, at: key]
      }
    }
    self
  }

  def each_key: block {
    """
    @block @Block@ to be called with each key in @self.
    @return @self

    Calls a given @Block@ with each key.
    """

    keys each: block
    self
  }

  def each_value: block {
    """
    @block @Block@ to be called with each value in @self.
    @return @self

    Calls a given @Block@ with each value.
    """

    values each: block
    self
  }

  def to_a {
    """
    @return @Array@ of all key-value pairs in @self.

    Returns an @Array@ of the key-value pairs in a @Hash@.
    """

    map: |pair| { pair }
  }

  def to_object {
    """
    @return New @Object@ with slots defined by keys and values in @self.

    Creates and returns a new @Object@ with slot names and values based on keys and values in @self.

    Example:
          o = <['name => \"Christopher Bertels\", 'interest => \"programming languages\"]> to_object
          o name        # => \"Christopher Bertels\"
          o interest    # => 42
    """

    o = Object new
    self each: |k v| {
      o set_slot: k value: v
    }
    o metaclass read_write_slots: keys
    o
  }

  def to_object_deep {
    """
    Similar to @Hash#to_object@ but converting any nested @Hash@ slots to @Object@s as well.
    """

    o = dup to_hash_deep to_object
    o slots each: |s| {
      val = o get_slot: s
      match val {
        case Hash >< Block -> o set_slot: s value: $ val to_object_deep
      }
    }
    o
  }

  def inspect {
    str = "<["
    each: |key val| {
      str << (key inspect)
      str << " => "
      str << (val inspect)
    } in_between: {
      str << ", "
    }
    str << "]>"
    str
  }

  def to_s {
    inspect
  }

  def values_at: keys {
    """
    @keys Collection of keys to get the values for.
    @return @Array@ of all values for the given keys.

    Example:
          <['foo => 1, 'bar => 2, 'baz => 42]> values_at: ('foo, 'baz) # => [1, 42]
    """

    keys map: |k| { at: k }
  }

  def select_keys: block {
    """
    @block @Block@ to be called with each key in @self.
    @return @Hash@ of entries for which @block called with its key yields @true.

    Example:
          h = <['a => 1, 42 => (1,2,3), 'b => \"hello\"]>
          h select_keys: @{ is_a?: Symbol } # => <['a => 1, 'b => \"hello\"]>
    """

    h = <[]>
    keys each: |k| {
      if: (block call: [k]) then: {
        h[k]: $ self[k]
      }
    }
    h
  }

  def reject_keys: block {
    """
    @block @Block@ to be called with each key in @self.
    @return @Hash@ of entries for which @block called with its key yields @false.

    Example:
          h = <['a => 1, 42 => (1,2,3), 'b => \"hello\"]>
          h reject_keys: @{ is_a?: Symbol } # => <[42 => (1,2,3)]>
    """

    select_keys: |k| { block call: [k] . not }
  }

  def random_key {
    """
    @return Random key in @self.
    """

    keys random
  }

  def random_value {
    """
    @return Random value in @self.
    """

    values random
  }

  def random {
    """
    @return Random value in @self.

    Same as @Hash#random_value@.
    """

    random_value
  }

  def call: receiver {
    """
    @receiver Receiver to apply @self to.
    @return @receiver.

    Sends each key-value pair as a message (with one argument) to @receiver.

    Example:
          Person = Struct new: ('firstname, 'lastname)
          p = Person new
          <['firstname => \"Tom\", 'lastname => \"Cruise\"]> call: [p]

          p firstname # => \"Tom\"
          p lastname  # => \"Cruise\"
    """

    to_block call: receiver
  }

  def to_hash_deep {
    h = dup
    h each: |k v| {
      match v {
        case Block -> h[k]: $ v to_hash_deep
      }
    }
    h
  }

  def to_block {
    """
    @return @Block@ that sends each key-value pair in @self as a message (with one argument) to its argument.

    Example:
          <['x => 100, 'y => 150]> to_block
          # would be the same as:
          |receiver| {
            receiver tap: @{
              x: 100
              y: 150
            }
          }
    """

    |receiver| {
      each: |k v| {
        match k to_s {
          case /:/ -> receiver receive_message: k with_params: [v]
          case _ -> receiver receive_message: "#{k}:" with_params: [v]
        }
      }
      receiver
    }
  }

  def update_values: block {
    """
    @block @Block@ that returns an updated value for each value in @self.

    Example:
          h = <['name => \"Tom\", 'age => 21 ]>
          h update_values: @{ * 2}
          h # => <['name => \”TomTom\”, 'age => 42]>
    """

    each: |k v| {
      self[k]: $ block call: [v]
    }
  }

  def update_keys: block {
    """
    @block @Block@ that returns an updated key for each key in @self.

    Example:
          h = <['name => \"Tom\", 'age => 21 ]>
          h update_keys: @{ to_s * 2}
          h # => <[\"namename\" => \”Tom\”, \"ageage\" => 21]>
    """

    deletions = []
    insertions = <[]>

    each: |k v| {
      new_key = block call: [k]
      if: (new_key != k) then: {
        deletions << k
        insertions[new_key]: v
      }
    }

    deletions each: |k| { delete: k }
    insertions each: |k v| {
      self[k]: v
    }
  }

  def with_updated_values: block {
    """
    @block @Block@ that returns an updated value for each value in @self.
    @return @Hash@ based on self but with updated values via @block.
    """

    dup update_values: block
  }

  def with_updated_keys: block {
    """
    @block @Block@ that returns an updated key for each key in @self.
    @return @Hash@ based on self but with updated keys via @block.
    """

    dup update_keys: block
  }

  def with_value_for_key: key do: block else: else_block ({}) {
    """
    @key Key of value to find in @self.
    @block @Block@ to be called with value for @key, if found.
    @else_block @Block@ to be called if @key not found in @self.
    """

    if: (includes?: key) then: {
      block call: [at: key]
    } else: else_block
  }
}
