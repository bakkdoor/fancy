require("actor")

class Actor {
  """
  Primitive Actor class.
  Actors can be sent messages asynchronously. They process incoming messages
  (which can be any object, including Tuples, Arrays, Numbers ...) in a
  first-come, first-serve manner.

  Actors are used to implement asynchronous and future message sends in Fancy
  using the @@ and @@@ syntax.

  Example usage:

      a = Actor spawn: {
        loop: {
          match Actor receive {
            case 'hello -> \"Hello World\" println
            case 'quit ->
              \"OK, done!\" println
              break # Quit loop and let actor die
          }
        }
      }

      10 times: {
        a ! 'hello # send 'hello to actor asynchronously
      }
      a ! 'quit
  """

  alias_method(':!, '<<)

  forwards_unary_ruby_methods
  metaclass forwards_unary_ruby_methods

  def Actor spawn: block {
    """
    @block @Block@ that represents the @Actor@'s code body to be executed in a new @Thread@.
    @return A new @Actor@ running @block in a seperate @Thread@.

    Example usage:

          Actor spawn: {
            loop: {
              Actor receive println # print all incoming messages
            }
          }
    """

    Actor spawn(&block)
  }
}
