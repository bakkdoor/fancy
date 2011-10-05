class String {

  # prepend a : to fancy version of ruby methods.
  ruby_aliases: [
    '==, 'upcase, 'downcase, '=~, 'to_i, 'to_f,
    'chomp, 'inspect, 'to_sym, '<, '>
  ]

  alias_method: '[]: for_ruby: '[]=
  alias_method: 'scan: for_ruby: 'scan

  forwards_unary_ruby_methods

  def [index] {
    """Given an Array of 2 Numbers, it returns the substring between the given indices.
       If given a Number, returns the character at that index."""

    # if given an Array, interpret it as a from:to: range substring
    if: (index is_a?: Array) then: {
      from: (index[0]) to: (index[1])
    } else: {
      ruby: '[] args: [index] . chr
    }
  }

  def from: from to: to {
    """
    @from Start index.
    @to End index.
    @return Substring starting at index @from and ending at @to.

    Returns a Substring from @from to @to.
    """
    ruby: '[] args: [(from .. to)]
  }

  def each: block {
    """
    @block @Block to be called for each character in @self.

    Calls a given @Block with each character in a @String.
    """
    split("") each: block
  }

  def at: idx {
    """
    @idx Index of the character to retrieve.
    @return Character in @self at position @idx.

    Returns the character (as a @String) at index @idx.
    """
    self[idx]
  }

  def split: str {
    """
    @str @String where @self should be split at.
    @return An @Array of @String values in @self that are seperated by @str.
    """
    split(str)
  }

  def split {
    """
    @return @Array of all non-whitespace Substrings in @self.

    Splits a string by whitespace.
    """
    split()
  }

  def eval {
    """
    @return Value of evaluating @self as Fancy code.

    Evaluates a @String in the current @Binding and returns its value.
    """
    binding = Binding setup(Rubinius VariableScope of_sender(),
                            Rubinius CompiledMethod of_sender(),
                            Rubinius StaticScope of_sender())
    Fancy eval: self binding: binding
  }

  def eval_global {
    "Same as @String#eval but evaluates @self in the global binding."
    Fancy eval: self
  }

  def to_sexp {
    "Not implemented yet!" raise!
  }

  def raise! {
    "Raises a new StdError with @self as the message."
    StdError new: self . raise!
  }

  def % values {
    ruby: '% args: [values to_a]
  }

  def unpack: format {
    unpack(format)
  }

  def replace: pattern with: replacement {
    if: (replacement is_a?: Block) then: {
      gsub(pattern, &replacement)
    } else: {
      gsub(pattern, replacement)
    }
  }

  def replace!: pattern with: replacement {
    if: (replacement is_a?: Block) then: {
      gsub!(pattern, &replacement)
    } else: {
      gsub!(pattern, replacement)
    }
  }

  def append: string {
    """
    @string Other @String@ to append on @self.
    @return @self, but modified.

    Appends another @String@ onto this @String@.

    Example usage:
        str = \"hello\"
        str append: \" world!\"
        str # => \"hello world!\"
    """

    append(string)
  }

  def includes?: substring {
    """
    @substring @String@ to be checked if it's in @self.
    @return @true if @substring is in @self, @false otherwise.

    Indicates if a given substring is in @self.
    """

    include?(substring)
  }
}
