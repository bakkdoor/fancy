class Hash {
  forwards_unary_ruby_methods

  alias_method: ":[]" for: '[]
  alias_method: 'at:put: for: "[]="
  alias_method: '[]: for: "[]="
  alias_method: 'at: for: '[]
  ruby_alias: '==

  def inspect {
    str = "<["
    max = size - 1
    i = 0
    each: |key,val| {
      str << (key inspect)
      str << " => "
      str << (val inspect)
      { str << ", " } if: (i < max)
      i = i + 1
    }
    str << "]>"
    str
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
}
