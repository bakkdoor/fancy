def class String {
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
    Kernel eval: ~[self]
  }

  def eval_global {
    "Not implemented yet!" raise!
  }

  def to_sexp {
    "Not implemented yet!" raise!
  }

  def raise! {
    "Raises a new StdError with self as the message."
    StdError new: self . raise!
  }
}
