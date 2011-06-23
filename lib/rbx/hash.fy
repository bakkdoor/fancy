class Hash {
  forwards_unary_ruby_methods

  alias_method: ":[]" for: '[]
  alias_method: 'at:put: for: "[]="
  alias_method: '[]: for: "[]="
  alias_method: 'at: for: '[]
  ruby_alias: '==

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
}
