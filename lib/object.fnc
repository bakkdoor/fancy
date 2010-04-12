# package: Fancy::Lang

def class Object {
  def loop: block {
    { true } while_true: {
      block call
    }
  }

  def println {
    Console println: self
  }

  def print {
    Console print: self
  }

  def != other {
    self == other not
  }

  def if_false: block {
    nil
  }

  def if_nil: block {
    nil
  }
  
  def nil? {
    nil
  }

  def false? {
    nil
  }

  def true? {
    nil
  }

  def if_do: block {
    self nil? if_true: {
      nil
    } else: {
      block call: self
    }
  }

  def if_do: then_block else: else_block {
    self nil? if_true: {
      else_block call
    } else: {
      then_block call: self
    }
  }

  def or_take: other {
    self nil? if_true: {
      other nil? if_false: {
        other
      }
    } else: {
      self
    }
  }
}
