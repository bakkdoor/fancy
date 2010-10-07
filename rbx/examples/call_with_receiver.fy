block = { self foo }

def class Foo {
  def foo {
    "in Foo#foo!" println
  }
}

block call_with_receiver: (Foo new)
