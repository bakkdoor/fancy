# package: Fancy::Lang

def class Object {
  def loop: block {
    "Infinitely calls the block (loops).";
    { true } while_true: {
      block call
    }
  }

  def println {
    "Same as Console println: self. Prints the object on STDOUT, followed by a newline.";
    Console println: self
  }

  def print {
    "Same as Console print: self. Prints the object on STDOUT.";
    Console print: self
  }

  def != other {
    "Indicates, if two objects are unequal.";
    self == other not
  }

  def if_false: block {
    "Calls the block.";
    nil
  }

  def if_nil: block {
    "Returns nil.";
    nil
  }
  
  def nil? {
    "Returns nil.";
    nil
  }

  def false? {
    "Returns nil.";
    nil
  }

  def true? {
    "Returns nil.";
    nil
  }

  def if_do: block {
    "If the object is non-nil, it calls the given block with itself as argument.";

    self nil? if_true: {
      nil
    } else: {
      block call: [self]
    }
  }

  def if_do: then_block else: else_block {
    ""If the object is non-nil, it calls the given then_block with itself as argument.
      Otherwise it calls the given else_block with itself as argument."";    

    self nil? if_true: {
      else_block call
    } else: {
      then_block call: [self]
    }
  }

  def or_take: other {
    "Returns self if it's non-nil, otherwise returns the given object.";

    self nil? if_true: {
      other
    } else: {
      self
    }
  }
  
  def to_num {
    0
  }

  def to_a {
    [self]
  }
  
  NATIVE def is_a?: class_obj {
    "Indicates, if an object is an instance of a given Class.";
    
    self _class subclass?: class_obj
  }
}
