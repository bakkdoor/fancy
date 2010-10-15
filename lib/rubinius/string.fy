def class String {

  # prepend a : to fancy version of ruby methods.
  alias_method: ":+" for: "+"

  def from: from to: to {
    self[~[from, to]]
  }

  def each: block {
    self each_char: ~[block]
  }

  def at: idx {
    self[idx]
  }

  def split: str {
    split: ~[str]
  }

  def eval {
    Fancy eval: ~[self]
  }

  def eval_global {
    Fancy eval: ~[self]
  }

  def to_sexp {
    "Not implemented yet!" raise!
  }

  def raise! {
    "Raises a new StdError with self as the message."
    StdError new: self . raise!
  }
}
