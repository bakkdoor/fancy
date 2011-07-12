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
    def Label [name]: pos {
      @@registry[name]: pos
    }

    def initialize: @line name: @name
    def bytecode: g {
      Label[@name]: $ g ip
      g push_nil()
    }
  }

  class Goto : Node {
    def initialize: @line label_name: @label_name

    def bytecode: g {
      pos = Label[@label_name]
      { "Label not found: #{@label_name}" raise! } unless: pos
      tmp_ip = g ip
      g ip: pos
      label = g new_label()
      label set!()
      g ip: tmp_ip
      g goto(label)
    }
  }
}