class Hash {
  """
  Class for Hashes (HashMaps / Dictionaries).
  Maps a key to a value.
  """

  include: FancyEnumerable

  def [] key {
    """
    @key Key for value to get.
    @return Value for given @key or @nil, if @key not set.

    Returns the value for a given key.
    """

    at: key
  }

  def each: block {
    """
    @block @Block@ to be called with each key and value in @self.
    @return @self
    Calls a given @Block@ with each key and value.
    """

    if: (block argcount == 1) then: {
      keys each: |key| {
        block call: [[key, at: key]]
      }
    } else: {
      keys each: |key| {
        block call: [key, at: key]
      }
    }
  }

  def each_key: block {
    """
    @block @Block@ to be called with each key in @self.
    @return @self

    Calls a given @Block@ with each key.
    """

    keys each: |key| {
      block call: [key]
    }
  }

  def each_value: block {
    """
    @block @Block@ to be called with each value in @self.
    @return @self

    Calls a given @Block@ with each value.
    """

    values each: |val| {
      block call: [val]
    }
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
}
