class FancyEnumerator {
  def initialize: @object {
    @iterator = 'each:
    rewind
  }

  def initialize: @object with: @iterator {
    rewind
  }

  def next {
    if: @peeked then: {
      @peeked = false
      @peek
    } else: {
      result = @fiber resume
      if: (@fiber alive?) then: {
        return result
      } else: {
        (Fancy StopIteration new: result) raise!
      }
    }
  }

  def peek {
    """
    Returns the next object in the FancyEnumerator, but doesn't move the
    internal position forward.
    When the position reaches the end, a Fancy StopIteration exception is
    raised.

    a = [1,2,3]
    e = a to_enum
    e next p #=> 1
    e peek p #=> 2
    e peek p #=> 2
    e peek p #=> 2
    e next p #=> 2
    e next p #=> 3
    e next p #=> raises Fancy StopIteration
    """

    unless: @peeked do: {
      @peeked = true
      @peek = @fiber resume
      if: (@fiber alive?) then: {
        return @peek
      } else: {
        (Fancy StopIteration new: result) raise!
      }
    }

    return @peek
  }

  def rewind {
    @peeked = false
    @peek = nil

    @fiber = Fiber new: {
      param = |element| { yield: element }
      @object send_message: @iterator with_params: [param]
    }
  }

  def with: object each: block {
    loop: {
      try {
        block call: [next, object]
      } catch (Fancy StopIteration) => ex {
        return object
      }
    }

    return object
  }
}
