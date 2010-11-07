class String {
  """
  Strings are sequences of characters and behave as such.
  All literal Strings within Fancy code are instances of the String
  class.

  They also include FancyEnumerable, which means you can use all the
  common sequence methods on them, like +map:+, +select:+ etc.
  """

  include: FancyEnumerable

  def ++ other {
    "Concatenate the String with another String"

    self + (other to_s)
  }

  def whitespace? {
    "Indicates, if a String is empty or a single whitespace character."

    self empty? or: (self == " ")
  }

  def blank? {
    "Indicates, if a String consists only of whitespace."

    self =~ /^\s*$/ if_do: {
      true
    } else: {
      false
    }
  }

  def * num {
    "Returns a string that is the num-fold concatenation of itself."

    str = ""
    num to_i times: {
      str = str ++ self
    }
    str
  }

  def raise! {
    "Raises a new StdError with self as the message."
    StdError new: self . raise!
  }
}
