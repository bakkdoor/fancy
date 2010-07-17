def class String {
  self include: Enumerable;

  def [] index {
    """Given an Array of 2 Numbers, it returns the substring between the given indices.
       If given a Number, returns the character at that index.""";

    # if given an Array, interpret it as a from:to: range substring
    index is_a?: Array . if_true: {
      self from: (index[0]) to: (index[1])
    } else: {
      self at: index
    }
  }

  def ++ other {
    "Concatenate the String with another String";

    self + (other to_s)
  }

  def whitespace? {
    "Indicates, if a String is empty or a single whitespace character.";

    self empty? or: (self == " ")
  }

  def blank? {
    "Indicates, if a String consists only of whitespace.";

    self all?: :whitespace?
  }

  def * num {
    "Returns a string that is the num-fold concatenation of itself.";

    str = "";
    num times: {
      str = (str ++ self)
    };
    str
  }
}
