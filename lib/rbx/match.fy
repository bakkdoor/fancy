class Match {
  def initialize: @obj

  # def case: @c {
  #   self
  # }

  # def -> block {
  #   case: @c do: block
  # }

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
  @@__matches__ = []

  def match: block {
    @@__matches__ unshift(Match new: self)
    val = block call
    val = @@__matches__ shift() value
    val
  }

  def case: c do: block {
    @@__matches__ first case: c do: block
  }

  def else: block {
    @@__matches__ first else: block
  }
}