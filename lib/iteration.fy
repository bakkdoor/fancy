class Fancy {
  class BreakIteration : StdError {
    """
    Raised to break the current iteration.
    It is rescued by Block#loop.

    Example:
          10 times: |i| {
              i println
              if: (i == 3) then: {
                Fancy BreakIteration new raise!
              }
          }
          \"Done!\" println

    Produces:
          0
          1
          2
          3
          Done!
    """

    read_slot: 'result
    def initialize: @result
  }

  class NextIteration : StdError {
    """
    Raised to continue with next iteration (and stopping the current one).
    It is rescued by Block#loop.
    """

    read_slot: 'result
    def initialize: @result
  }

  class StopIteration : StdError {
    """
    Raised to stop the iteration, in particular by Enumerator#next.
    It is rescued by Block#loop.

    Example:
          {
            'Hello println
            Fancy StopIteration new raise!
            'World println
          } loop
          'Done! println

    Produces:
          Hello
          Done!
    """

    def initialize: @result (nil);

    def result {
      """
      Returns the return value of the iterator.

            o = Object new
            def o each: block {
              block call: [1]
              block call: [2]
              block call: [3]
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
