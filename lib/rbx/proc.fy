class Proc {
  forwards_unary_ruby_methods
  alias_method: 'call for_ruby: 'call
  def call: args {
    call(*args)
  }
}