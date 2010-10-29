match "foobarbaz" -> {
  case r/foo([a-z]+)baz/ -> |matcher|
    matcher[0] println  # => bar
}
