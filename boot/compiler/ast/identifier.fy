class Fancy AST {

  class Identifier : Node {
    read_slots: ['string, 'line, 'ruby_]
    def initialize: @line string: @string {}

    def name {
      @string to_sym()
    }

    def method_name: receiver ruby_send: ruby (false) {
      ruby if_do: {
        @string to_sym()
      } else: {
        @string =~ /:$/ . if_do: {
          @string to_sym()
        } else: {
          ":" + @string . to_sym()
        }
      }
    }

    def self from: string line: line {
      type = match string -> {
        case /^[A-Z].*::/ -> NestedConstant
        case /^[A-Z]/ -> Constant
        case /^@@/ -> ClassVariable
        case /^@/ -> InstanceVariable
        case _ -> Identifier
      }
      type new: line string: string
    }

    def bytecode: g {
      match @string -> {
        case "true" -> g push_true()
        case "false" -> g push_false()
        case "nil" -> g push_nil()
        case "self" -> g push_self()
        case _ -> Rubinius AST LocalVariableAccess new(@line, self name) bytecode(g)
      }
    }
  }

  class InstanceVariable : Identifier {
    def initialize: @line string: @string {}
    def bytecode: g {
      Rubinius AST InstanceVariableAccess new(@line, self name) bytecode(g)
    }
  }

  class ClassVariable : Identifier {
    def initialize: @line string: @string {}
    def bytecode: g {
      Rubinius AST ClassVariableAccess new(@line, self name) bytecode(g)
    }
  }

  class Constant : Identifier {
    def initialize: @line string: @string {}
    def bytecode: g {
       Rubinius AST ConstantAccess new(@line, self name) bytecode(g)
    }
  }

  class NestedConstant : Identifier {
    def initialize: @line string: @string {
    }

    def bytecode: g {
      names = @string split: "::"
      parent = Constant new: @line string: (names shift())
      names each: |name| {
        Rubinius AST ScopedConstant new(@line, parent, name to_sym()) bytecode(g)
        parent = Constant new: @line string: name
      }
      @scoped = parent
    }
  }

}
