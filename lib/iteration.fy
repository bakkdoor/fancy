class Fancy {
  class BreakIteration : StdError {
    read_slots: ['result]
    def initialize: @result {}
  }

  class NextIteration : StdError {
    read_slots: ['result]
    def initialize: @result {}
  }

  class StopIteration : StdError {
    """
    Raised to stop the iteration, in particular by Enumerator#next.
    It is rescued by Block#loop.

    Example:
      {
        'Hello println
        StopIteration new raise!
        'World println
      } loop
      'Done! println

    Produces:

      Hello
      Done!
    """

    def initialize { @result = nil }
    def initialize: @result { }

    def result {
      """
      Returns the return value of the iterator.

        o = Object new
        def o each: block {
          block call: 1
          block call: 2
          block call: 3
          100
        }

        e = o to_enum
        e next p #=> 1
        e next p #=> 2
        e next p #=> 3
        try {
          e next
        } catch Fancy StopIteration => ex {
          ex result p #=> 100
        }
      """

      @result
    }
  }
}
