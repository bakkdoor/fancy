*stdin*      = STDIN
*stdout*     = STDOUT
*stderr*     = STDERR
*fancy_root* = File absolute_path: $ File join: (File dirname: __FILE__, "..")

__AFTER__BOOTSTRAP__: {
  *stdin* documentation: """
    The Standard Input stream.
    Can be rebound to any @IO@ stream via @Object#let:be:in:@.
  """

  *stdout* documentation: """
    The Standard Output stream.
    Can be rebound to any @IO@ stream via @Object#let:be:in:@.
  """

  *stderr* documentation: """
    The Standard Error Output stream.
    Can be rebound to any @IO@ stream via @Object#let:be:in:@.
  """
}