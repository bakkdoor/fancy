class Integer {
  # common ruby-forwarding methods used by Fixnum & Bignum classes

  def times: block {
    times(&block)
  }
}