class Object {
  def to_enum {
    FancyEnumerator new: self
  }

  def to_enum: iterator {
    FancyEnumerator new: self method: iterator
  }
}

class FancyEnumerator {
  def initialize: @object {
    @iterator = 'each
    rewind
  }

  def initialize: @object with: @iterator {
    rewind
  }

  def next {
    @peeked if_do: {
      @peeked = false
      @peek
    } else: {
      @fiber resume
    }
  }

  def peek {
    unless: @peeked do: {
      @peeked = true
      @peek = @fiber resume
    }

    @peek
  }

  def rewind {
    @peeked = false
    @peek = nil

    @fiber = Fiber new: {
      @object each: |element| {
        yield: element
      }
    }
  }
}
