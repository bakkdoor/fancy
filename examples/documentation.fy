class Foo {

  """
  If first expression in a class body is an string literal
  it is used as documentation.
  """

  m = def foo: x bar: y = 22 {
    "Prints its own documentation."
    "TODO: obtain methodContext and print own documentation" println
  }
  m documentation println

}

foo = Foo new

foo method: 'foo:bar: . documentation println
foo method: 'foo: . documentation println

def foo bar: n {
   "A singleton method"
   n println
}

foo method: 'bar: . documentation println

Foo instance_method: 'foo: . documentation println

Foo documentation println

block = |a, b| {
  "A block can also have a documentation string, just like methods"
  a + b
}

block documentation println
