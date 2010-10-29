match "foobarbaz" -> {
  case r{foo([a-z]+)baz} -> |matcher|
    matcher[1] println  # => bar
}
