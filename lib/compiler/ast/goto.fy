class Rubinius Generator {
  def ip: @ip
  def ip {
    @ip
  }
}

class Fancy AST {
  class Label : Node {
    @@registry = <[]>
    def Label [name] {
      @@registry[name]
    }
    def Label [name]: label {
      @@registry[name]: label
    }

    def initialize: @line name: @name
    def bytecode: g {
      pos(g)
      label = Label[@name]
      unless: label do: {
        label = g new_label()
        Label[@name]: label
      }
      tmp = g ip
      g ip: (tmp + 2)
      label set!()
      g ip: tmp
      g push_nil()
    }
  }

  class Goto : Node {
    def initialize: @line label_name: @label_name
    def bytecode: g {
      pos(g)
      label = Label[@label_name]
      unless: label do: {
        label = g new_label()
        Label[@label_name]: label
      }
      g goto(label)
    }
  }
}