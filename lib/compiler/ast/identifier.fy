class Fancy AST {
  class Identifier : Node {
    read_slots: ['string, 'line]
    read_write_slot: 'ruby_ident

    @@gen_ident_start = 0

    def Identifier generate: line {
      """
      @line Line to be set for generated Identifier.
      @return New generated Identifier, e.g. \"______gen_ident______1\"

      Generates a new Identifier using a simple counter.
      """

      @@gen_ident_start = @@gen_ident_start + 1
      Identifier from: ("______gen_ident______" ++ @@gen_ident_start) line: line
    }

    def initialize: @line string: @string ruby_ident: @ruby_ident (false) {
    }

    def name {
      @string to_sym()
    }

    def method_name: receiver ruby_send: ruby (false) {
      ruby || @ruby_ident if_true: {
        @string to_sym()
      } else: {
        @string =~ /:$/ . if_true: {
          @string to_sym()
        } else: {
          ":" + @string . to_sym()
        }
      }
    }

    def self from: string line: line filename: filename (nil) {
      type = string match: {
        case: "__FILE__" do: { return CurrentFile new: line filename: filename }
        case: "__LINE__" do: { return CurrentLine new: line }
        case: "self" do: { return Self new: line }
        case: /^[A-Z].*::/ do: NestedConstant
        case: /^[A-Z]/ do: Constant
        case: /^@@/ do: ClassVariable
        case: /^@/ do: InstanceVariable
        case: _ do: Identifier
      }
      type new: line string: string
    }

    def bytecode: g {
      pos(g)
      @string match: {
        # case "true" -> g push_true()
        # case "false" -> g push_false()
        # case "nil" -> g push_nil()
        case: _ do: {
          if: (g state() scope() search_local(name)) then: {
            Rubinius AST LocalVariableAccess new(@line, name) bytecode(g)
          } else: {
            ms = MessageSend new: @line message: self to: (Self new: @line) args: (MessageArgs new: @line args: [])
            ms bytecode: g
          }
        }
      }
    }
  }

  class InstanceVariable : Identifier {
    def initialize: @line string: @string {}
    def bytecode: g {
      pos(g)
      Rubinius AST InstanceVariableAccess new(@line, name) bytecode(g)
    }
  }

  class ClassVariable : Identifier {
    def initialize: @line string: @string {}
    def bytecode: g {
      pos(g)
      Rubinius AST ClassVariableAccess new(@line, name) bytecode(g)
    }
  }

  class Constant : Identifier {
    def initialize: @line string: @string {}
    def bytecode: g {
      pos(g)
      Rubinius AST ConstantAccess new(@line, name) bytecode(g)
    }
  }

  class NestedConstant : Identifier {
    def initialize: @line string: @string {
    }

    def initialize: @line const: const parent: parent {
      @string = (parent string) ++ "::" ++ (const string)
    }

    def scoped {
      names = @string split("::")
      parent = Constant new: @line string: (names shift())
      scoped = nil
      names each() |name| {
        scoped = Rubinius AST ScopedConstant new(@line, parent, name to_sym())
        parent = scoped
      }
      scoped
    }

    def bytecode: g {
      pos(g)
      scoped bytecode(g)
    }
  }
}
