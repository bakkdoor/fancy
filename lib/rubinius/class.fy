def class Class {

  # calls initialize:, if defined
  def new: arg {
    obj = self allocate: ~[]
    obj initialize: arg
    obj
  }

  def Class superclass: superclass body: body_block {
    ruby: 'new args: [superclass] with_block: body_block
  }

  def define_method: name with: block {
    # define_method: ~[name, block]
    ruby: 'define_method args: [name] with_block: block
  }

  def undefine_method: name {
    remove_method: ~[name]
  }

  def define_class_method: name with: block {
    define_singleton_method: name with: block
  }

  def undefine_class_method: name {
    undefine_singleton_method: name
  }

  def alias_method: new for: old {
    alias_method: ~[new, old]
  }

  def subclass: body_block {
    Class superclass: self body: body
  }

  def nestes_classes {
    "Not Yet Implemented" raise!
  }
}
