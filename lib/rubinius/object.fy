def class Object {

  def dclone {
    "Returns a deep clone of self using Ruby's Marshal class."
    Marshal load: $ Marshal dump: self
  }

  def docstring: docstring {
    "Sets the docstring for an Object."
    @docstring = docstring
  }

  def docstring {
    "Returns the docstring for an Object."
    @docstring
  }

  def if_do: block {
    "If the object is non-nil, it calls the given block with itself as argument."

    self nil? if_false: {
      block call: [self]
    }
  }

  def ++ other {
    self to_s + (other to_s)
  }

}
