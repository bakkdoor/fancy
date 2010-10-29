class Foo {

  m = def foo: x bar: y = 22 {
    "Prints its own documentation."
    "TODO: obtain methodContext and print own documentation" println
  }
  m documentation println

}

Foo new method: 'foo:bar: . documentation println
Foo new method: 'foo: . documentation println
Foo instance_method: 'foo: . documentation println
