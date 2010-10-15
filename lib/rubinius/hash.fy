def class Hash {

  alias_method: ":size" for: 'size
  alias_method: ":[]" for: '[]
  alias_method: 'at:put: for: "[]="
  alias_method: 'at: for: '[]


  def inspect {
    str = "<["
    max = self size - 1
    i = 0
    self each: |key,val| {
      str = str ++ (key inspect) ++ " => " ++ (val inspect)
      { str = str + ", " } if: (i < max)
      i = i + 1
    }
    str = str + "]>"
    str
  }

  def each: block {
    ruby: 'each with_block: block
  }

  def each_key: block {
    ruby: 'each_key with_block: block
  }

  def each_value: block {
    ruby: 'each_value with_block: block
  }

  def map: block {
    ruby: 'map with_block: block
  }
}
