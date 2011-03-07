class String {

  # prepend a : to fancy version of ruby methods.
  ruby_alias: '==
  ruby_alias: 'upcase
  ruby_alias: 'downcase
  ruby_alias: '=~
  ruby_alias: 'to_i
  ruby_alias: 'to_f
  ruby_alias: 'chomp
  ruby_alias: 'inspect

  def [] index {
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
    ruby: '[] args: [(from .. to)]
  }

  def each: block {
    split("") each(&block)
  }

  def at: idx {
    self[idx]
  }

  def split: str {
    split(str)
  }

  def split {
    split()
  }

  def eval {
    binding = Binding setup(Rubinius VariableScope of_sender(),
                            Rubinius CompiledMethod of_sender(),
                            Rubinius StaticScope of_sender())
    Fancy eval: self binding: binding
  }

  def eval_global {
    Fancy eval: self
  }

  def to_sexp {
    "Not implemented yet!" raise!
  }

  def raise! {
    "Raises a new StdError with self as the message."
    StdError new: self . raise!
  }
}
