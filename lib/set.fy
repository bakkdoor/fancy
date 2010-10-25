class Set {
  "A simple Set data structure class."

  include: FancyEnumerable
  read_slots: ['values]

  def initialize: arr {
    "Initialize a new Set with a given Array of values."
    @values = arr uniq
  }

  def initialize {
    "Initialize a new empty Set."
    @values = []
  }

  def == other {
    "Indicates, if two Sets are equal."
    other is_a?: Set . if_true: {
      @values == (other values)
    }
  }

  def Set [] arr {
    "Initialize a new Array with a given Array of values."
    Set new: arr
  }

  def << value {
    "Insert a value into the Set."
    { @values << value } unless: (includes?: value)
  }

  def includes?: value {
    "Indicates, if the Set includes a given value."
    @values includes?: value
  }

  def each: block {
    "Calls a given Block for each element of the Set."
    @values each: block
  }

  def unknown_message: msg with_params: params {
    params empty? if_true: {
      @values send: msg
    } else: {
      @values send: msg params: params
    }
  }

  def to_s {
    "Returns a String representation of a Set."
    "Set" ++ @values to_s
  }

  def inspect {
    "Returns a detailed String representation of a Set."
    self to_s ++ " : Set"
  }
}
