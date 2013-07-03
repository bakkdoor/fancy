class Hash {
  forwards_unary_ruby_methods

  alias_method: ":[]" for: '[]
  alias_method: 'at:put: for: "[]="
  alias_method: '[]: for: "[]="
  alias_method: 'at: for: '[]
  ruby_alias: '==

  def initialize: default {
    """
    @default Default value for @self.

    Initializes a new @Hash@ with @default as a default value.
    If @default is a @Block@, call it with @self and a given key to get its default value.
    """

    default: default
  }

  def each: block {
    each(&block)
  }

  def each_key: block {
    each_key(&block)
  }

  def each_value: block {
    each_value(&block)
  }

  def map: block {
    map(&block)
  }

  def delete: key {
    """
    @key Key of key-value pair to be deleted in @self.

    Deletes a key-value pair from @self.
    """

    delete(key)
  }

  def merge: other_hash {
    merge(other_hash)
  }

  def merge!: other_hash {
    merge!(other_hash)
  }

  def includes?: key {
    """
    @key Key to search for.
    @return @true, if Hash includes @key, @false otherwise.

    Indicates if a given key is in @self.
    """

    include?(key)
  }

  def default: default_value {
    """
    @default_value Default value for @self.

    Sets the default value to be returned from @self for keys not in @self.
    If @default_value is a @Block@, use its return value (called with the @Hash@ and a given key).
    """

    match default_value {
      case Block ->
        @got_default_proc = true
        @default = nil
        @default_proc = default_value
      case _ ->
        @got_default_proc = false
        @default = default_value
        @default_proc = nil
    }
  }

  def default {
    """
    @return Default value for @self.
    """

    if: @got_default_proc then: {
      @default_proc
    } else: {
      @default
    }
  }

  def default_for: key {
    """
    @key Key to be used.
    @return Default value for @key.
    """

    default(key)
  }
}
