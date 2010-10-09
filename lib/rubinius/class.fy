def class Class {

  # When calling new: we have to call rbx's standard 'new' method
  # which then in turn calls the 'initialize' method.
  # This is the other part around the 'initialize' vs 'initialize:'
  # problem. See rbx/compiler/ast/method_def.rb for more information.
  def new: args{
    new: ~[args]
  }
}
