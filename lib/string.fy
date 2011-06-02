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
    """
    @other Object to concatenate @self with as a @String@.
    @return Concatenation of @self with @other.

    Concatenate @self with another Object's @String@ representation.
        \"foo\” ++ 42 # => \”foo42\”
    """

    self + (other to_s)
  }

  def whitespace? {
    """
    @return @true, if @self consists only of a single whitespace character or is empty, @false otherwise.

    Indicates, if a @String@ is empty or a single whitespace character.
    """

    empty? or: (self == " ")
  }

  def blank? {
    """
    @return @true if @self consists only of whitespace, @false otherwise.

    Indicates, if a @String@ consists only of whitespace.
    """

    self =~ /^\s*$/ if_true: {
      true
    } else: {
      false
    }
  }

  def * num {
    """
    @num Amount of concatenations to do with @self.
    @return @String@ that is the num-fold concatenation of @self.

    Returns a @String@ that is the num-fold concatenation of itself.
        \"foo\" * 3 # => \”foofoofoo\"
    """

    str = ""
    num to_i times: {
      str = str ++ self
    }
    str
  }

  def words {
    """
    @return @Array@ of all the whitespace seperated words in @self.

        \"hello world\" words  # => [\"hello\", \"world\"]
    """

    split
  }

  def raise! {
    """
    Raises a new @StandardError@ with self as the message.
    """

    StandardError new: self . raise!
  }

  def rest {
    """
    @return @String@ containing all but the first character.

    Returns a @String@ containing all but the first character.
        \"hello\" rest # => \"ello\"
    """

    from: 1 to: -1
  }

  def lines {
    """
    @return @Array@ of all the lines in @self.

    Returns the lines of a @String@ as an @Array@.
    """

    split: "\n"
  }
}
