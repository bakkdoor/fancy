class String {
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

    all?: |c| {
      c whitespace?
    }
  }

  def * num {
    "Returns a string that is the num-fold concatenation of itself."

    str = ""
    num times: {
      str = str ++ self
    }
    str
  }

  def raise! {
    "Raises a new StdError with self as the message."
    StdError new: self . raise!
  }
}
