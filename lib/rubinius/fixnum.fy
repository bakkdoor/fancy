def class Fixnum {
  def times: block {
    ruby: 'times with_block: block
  }

  def upto: num do_each: block {
    ruby: 'upto args: [num] with_block: block
  }
}
