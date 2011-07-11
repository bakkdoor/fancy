class Match {
  def initialize: @obj

  def case: @c {
    self
  }

  def -> block {
    case: @c do: block
  }

  def case: c do: block {
    try {
      if: (c === @obj) then: |val| {
        @called = block
        if: (block is_a?: Block) then: {
          return block call: $ val to_a
        } else: {
          return block
        }
      } else: {
        self
      }
    } catch {
      # do nothing in case of error
    }
  }

  def else: block {
    unless: @called do: {
      if: (block is_a?: Block) then: {
        block call
      } else: {
        block
      }
    }
  }
}

class Object {
  def match: block {
    block call_on_instance(Match new: self)
  }
}
