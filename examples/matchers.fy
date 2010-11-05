# matchers.fy

match "foobarbaz" -> {
  case /foo([a-z]+)baz/ -> |matcher|
    matcher[1] println  # => bar
}
