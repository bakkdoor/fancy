class Hash {
  """
  Class for Hashes (HashMaps / Dictionaries).
  Maps a key to a value.
  """

  include: Fancy Enumerable

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
    """

    if: (includes?: key) then: {
      at: key
    } else: else_block
  }

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

  def to_s {
    """
    @return @String@ representation of @self.

    Returns a @String@ representation of a @Hash@.
    """

    to_a to_s
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

  def values_at: keys {
    """
    @keys Collection of keys to get the values for.
    @return @Array@ of all values for the given keys.

    Example:
          <['foo => 1, 'bar => 2, 'baz => 42]> values_at: ('foo, 'baz) # => [1, 42]
    """

    keys map: |k| { at: k }
  }

  def fetch: key else: else_block {
    """
    @key Key of value to get.
    @else_block @Block@ that gets called if @key not in @self.

    Example:
          <['foo => 'bar]> fetch: 'foo else: { 42 } # => 'bar
          <['foo => 'bar]> fetch: 'unknown else: { 42 } # => 42
          <['nil => nil]> fetch: 'nil else: { 'not_found } # => nil
    """

    if: (includes?: key) then: {
      at: key
    } else: {
      else_block call: [key]
    }
  }
}
