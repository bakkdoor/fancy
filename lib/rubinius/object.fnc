def class Object {

  def dclone {
    "Returns a deep clone of self using Ruby's Marshal class."
    Marshal load: $ Marshal dump: self
  }

  def docstring=: docstring {
    @docstring = docstring
  }

  def docstring {
    @docstring
  }

}
