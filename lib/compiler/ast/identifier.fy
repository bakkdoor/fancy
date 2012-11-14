class Fancy AST {
  class Identifier : Node {
    read_slots: ('string, 'line)
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
      match @string {
        case /^ | $/ -> @string = "|"
      }
    }

    def name {
      @string to_sym
    }

    def method_name: receiver ruby_send: ruby (false) {
      if: (ruby || @ruby_ident) then: {
        @string to_sym
      } else: {
        if: (@string =~ /:$/) then: {
          @string to_sym
        } else: {
          ":" + @string . to_sym
        }
      }
    }

    def self from: string line: line filename: filename (nil) {
      type = match string {
        case "__FILE__" -> return CurrentFile new: line filename: filename
        case "__LINE__" -> return CurrentLine new: line
        case "self" -> return Self new: line
        case /^::/ -> ToplevelConstant
        case /^[A-Z].*::/ -> NestedConstant
        case /^[A-Z]/ -> Constant
        case /^@@/ -> ClassVariable
        case /^@/ -> InstanceVariable
        case /^\*[a-zA-Z0-9_-]+\*$/ -> DynamicVariable
        case _ -> Identifier
      }
      type new: line string: string
    }

    def bytecode: g {
      pos(g)
      match @string {
        case "true" -> g push_true()
        case "false" -> g push_false()
        case "nil" -> g push_nil()
        case _ ->
          if: (g state() scope() search_local(name)) then: {
            Rubinius AST LocalVariableAccess new(@line, name) bytecode(g)
          } else: {
            ms = MessageSend new: @line message: self to: (Self new: @line) args: (MessageArgs new: @line args: [])
            ms bytecode: g
          }
      }
    }
  }

  class InstanceVariable : Identifier {
    def initialize: @line string: @string
    def bytecode: g {
      pos(g)
      Rubinius AST InstanceVariableAccess new(@line, name) bytecode(g)
    }
  }

  class ClassVariable : Identifier {
    def initialize: @line string: @string
    def bytecode: g {
      pos(g)
      Rubinius AST ClassVariableAccess new(@line, name) bytecode(g)
    }
  }

  class Constant : Identifier {
    def initialize: @line string: @string
    def bytecode: g {
      pos(g)
      Rubinius AST ConstantAccess new(@line, name) bytecode(g)
    }
  }

  class NestedConstant : Identifier {
    def initialize: @line string: @string

    def initialize: @line const: const parent: parent {
      @string = (parent string) ++ "::" ++ (const string)
    }

    def scoped {
      names = @string split: "::"
      parent = nil
      match @string {
        case /^::/ ->
          names = names rest
          parent = ToplevelConstant new: @line string: "::#{names shift}"
        case _ ->
          parent = Constant new: @line string: $ names shift
      }
      scoped = nil
      names each: |name| {
        scoped = Rubinius AST ScopedConstant new(@line, parent, name to_sym)
        parent = scoped
      }
      scoped
    }

    def bytecode: g {
      pos(g)
      scoped bytecode(g)
    }
  }

  class ToplevelConstant : Identifier {
    def initialize: @line string: @string

    def bytecode: g {
      pos(g)
      const_name = @string from: 2 to: -1 . to_sym # skip leading ::
      Rubinius AST ToplevelConstant new(@line, const_name) . bytecode(g)
    }
  }

  class DynamicVariable : Identifier {
    read_slot: 'varname
    def initialize: @line string: @string {
      @varname = SymbolLiteral new: @line value: @string
    }

    def bytecode: g {
      thread = Identifier from: "Thread" line: @line
      thread bytecode: g
      g send('current, 0, false)
      @varname bytecode: g
      g send(':[], 1, false)
    }
  }
}
