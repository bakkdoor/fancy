class Integer {
  # common ruby-forwarding methods used by Fixnum & Bignum classes

  def times: block {
    # this version gets replaced in lib/integer.fy with a native one
    times(&block)
  }
}