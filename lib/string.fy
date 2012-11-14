class String {
  """
  Strings are sequences of characters and behave as such.
  All literal Strings within Fancy code are instances of the String
  class.

  They also include @Fancy::Enumerable@, which means you can use all the
  common sequence methods on them, like @Fancy::Enumerable#map:@, @Fancy::Enumerable#select:@ etc.
  """

  include: Fancy Enumerable

  instance_method: '== . documentation: """
    Compares @self to another @String@ and returns @true, if equal, @false otherwise.
  """

  instance_method: 'uppercase . documentation: """
    @return Uppercased version of @self.

    Example:
          \"hello world\" uppercase # => \"HELLO WORLD\"
  """

  instance_method: 'lowercase . documentation: """
    @return Lowercased version of @self.

    Example:
          \"HELLO WORLD\" lowercase # => \"hello world\"
  """

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

    Example:
          \"foo\" * 3 # => \"foofoofoo\"
    """

    str = ""
    num to_i times: {
      str << self
    }
    str
  }

  def words {
    """
    @return @Array@ of all the whitespace seperated words in @self.

    Example:
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

  def << object {
    """
    @object An @Object@ who's @String@ representation will be appended to @self.
    @return @self, but modified.

    Appends @object's @String@ representation to @self.

    Example:
          str = \"hello\"
          str << \" \"
          str << 42
          str # => \"hello 42\"
    """

    append: $ object to_s
  }

  def skip_leading_indentation {
    """
    Remove leading white space for multi-line strings.
    This method expects the first character to be an line return.
    """

    str = self
    m = /^(\r?\n)*(\s+)/ match(str)
    str = str strip()
    if: m then: {
      pattern = "^ {" ++ (m[2] size()) ++ "}"
      rex = Regexp.new(pattern)
      str = str gsub(rex, "");
    }
    str
  }

  def characters {
    """
    @return @Array@ of all characters (as @String@) in @self.
    """

    scan: /./
  }

  def character {
    """
    @return @Fixnum@ (byte / ASCII) value of first character in @self.
    """

    self bytes each: |c| {
      return c
    }
    return nil
  }

  def bytes {
    """
    @return @Fancy::Enumerator@ of all bytes (@Fixnum@ values) in @self.
    """

    enum = bytes()
    def enum each: block {
      each(&block)
    }
    Fancy Enumerator new: enum
  }

  def relative_path: path {
    """
    @path Relative path to @self.
    @return Absolute @File@ path relative to @self.

    Example:
          __FILE__ relative: \"../foo/bar\"
    """

    File expand_path: $ File dirname(self) + "/" + path
  }

  def multiline? {
    """
    @return @true if @self is a multiline string, @false otherwise.

    Example:
          \"foo\nbar\" multiline? # => true
          \"foo bar\" multiline?  # => false
          \"\" multiline?         # => false
          \"\n\n\n\" multiline?   # => true
    """

    grep: /\n/ . size > 0
  }

  def main? {
    """
    @return @true if @self is the filename of the script that got executed initially.
    """

    File expand_path: (ARGV[0] to_s) == self
  }

  def if_main: main_block else: else_block ({}) {
    """
    @main_block @Block@ to be run if @String#:main?@ returns true.
    @else_block @Block@ to be called otherwise.

    Same as:
          if: main? then: else_block else: else_block
    """

    if: main? then: main_block else: else_block
  }

  def snake_cased {
    """
    Returns a snake cased version of @self.
    """

    r1 = Regexp new("([A-Z]+)([A-Z][a-z])")
    r2 = Regexp new("([a-z\d])([A-Z])")
    gsub(r1,"\1_\2") gsub(r2,"\1_\2") tr("-", "_") lowercase
  }

  def camel_cased {
    """
    Returns camel cased version of @self which is expected
    to be a snake cased @String@.
    """

    self split: "_" . map: @{ capitalize } . join
  }

  def uppercase? {
    """
    @return @true if @self is completely uppercase, @false otherwise.

    Example:
        \"F\"   uppercase? # => true
        \"FOO\" uppercase? # => true
        \"f\”   uppercase? # => false
        \"Foo\" uppercase? # => false
    """

    { return false } if: blank?
    uppercase == self
  }

  def lowercase? {
    """
    @return @true if @self is completely lowercase, @false otherwise.

    Example:
        \"f\”   lowercase? # => true
        \"foo\" lowercase? # => true
        \"F\"   lowercase? # => false
        \"Foo\" lowercase? # => false
    """

    { return false } if: blank?
    lowercase == self
  }
}
