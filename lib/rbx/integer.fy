class Integer {
  # common ruby-forwarding methods used by Fixnum & Bignum classes

  def times: block {
    times(&block)
  }

  def upto: num do_each: block {
    upto(num, &block)
  }

  def downto: num do_each: block {
    downto(num, &block)
  }
}