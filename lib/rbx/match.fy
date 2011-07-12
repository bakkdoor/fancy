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
					@value = block call: $ val to_a
        } else: {
					@value = block
        }
        return @value
      } else: {
        return self
      }
    } catch {
      # do nothing in case of error
			return nil
    }
  }

  def else: block {
    unless: @called do: {
      if: (block is_a?: Block) then: {
        return block call
      } else: {
        return block
      }
    }
    return @value
  }
}

class Object {
  @@__matches__ = []

  def match: block {
    @@__matches__ unshift(Match new: self)
    val = block call
    @@__matches__ shift()
    val
  }

  def case: c do: block {
    @@__matches__ first case: c do: block
  }

  def else: block {
    @@__matches__ first else: block
  }
}