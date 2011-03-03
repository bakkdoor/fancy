class Hash {

  alias_method: ":size" for: 'size
  alias_method: ":[]" for: '[]
  alias_method: 'at:put: for: "[]="
  alias_method: 'at: for: '[]
  ruby_alias: 'keys
  ruby_alias: 'values
  ruby_alias: '==

  def inspect {
    str = "<["
    max = size - 1
    i = 0
    each: |key,val| {
      str = str ++ (key inspect) ++ " => " ++ (val inspect)
      { str = str + ", " } if: (i < max)
      i = i + 1
    }
    str = str + "]>"
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
}
