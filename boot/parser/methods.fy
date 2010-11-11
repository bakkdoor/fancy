class Fancy {
  class Parser {

    def self parse_file: filename line: line (1) {
      new: filename line: line . parse_file . script
    }

    read_write_slots: ['filename, 'line, 'script]

    def initialize: @filename line: @line { }

    def body: body {
      @script = AST Script new: @line file: @filename body: body
    }

    def ast: line exp_list: expr into: list (AST ExpressionList new: line) {
      expr if_do: { list expressions << expr }
      list
    }

    def ast: line identity: identity { identity }

    def ast: line concat: object into: ary ([]) {
      object kind_of?(Array) . if_do: {
        ary concat(object)
      } else: {
        ary << object
      }
    }

    def ast: line fixnum: text base: base (10) {
      AST FixnumLiteral new: (text to_i(base)) line: line
    }

    def ast: line number: text base: base (10) {
      AST NumberLiteral new: (text to_f()) line: line
    }

    def ast: line symbol: text {
      str = text from: 1 to: -1
      AST SymbolLiteral new: str line: line
    }

    def ast: line string: text {
      str = text from: 1 to: -2
      AST StringLiteral new: str line: line
    }

    def ast: line tuple: expr_ary {
      expr_ary size == 1 . if_do: { expr_ary first } else: {
        AST TupleLiteral new: expr_ary line: line
      }
    }

    def ast: line identifier: text {
      AST Identifier from: text line: line
    }

    def ast: line constant: identifier parent: parent {
      AST ScopedConstant new: (identifier name) line: line parent: parent
    }

    def ast: line super_exp: text { AST Super new: line }

    def ast: line retry_exp: text { AST Retry new: line }

    def ast: line assign: rvalue to: lvalue many: many (false) {
      ast = many if_do: { AST MultipleAssignment } else: { AST Assignment }
      ast new: rvalue to: lvalue line: line
    }

    def ast: line param: selector var: variable default: default (nil) {
      Struct.new('selector, 'variable, 'default) new(selector, variable, default)
    }

    def ast: line send: selector arg: value ary: ary ([]) {
      ary << $ Struct new('selector, 'value) new(selector, value)
    }

    def ast: line oper: oper arg: arg to: receiver (AST Self new line) ruby: ruby (false) {
      message = ast: line send: oper arg: arg
      ast: line send: message to: receiver ruby: ruby
    }

    def ast: line send: message to: receiver (AST Self new: line) ruby: ruby (false) {
      arg_type = ruby if_do: { AST RubyArgs } else: { AST MessageArgs }
      args = arg_type new: [] line: line
      name = message
      message kind_of?(String) . if_do: {
        name = AST Identifier from: message line: line
      }
      message kind_of?(Array) . if_do: {
        name = message map: |m| { m selector() string } . join
        name = AST Identifier new: name line: line
        args = message map: |m| { m value() }
        args = arg_type new: args line: line
      }
      AST MessageSend new: name to: receiver args: args line: line
    }

    def method_name: margs {
      margs map: |a| { a selector() string } . join("")
    }

    def method: margs delegators: block {
      idx = margs index() |m| { m default() != nil }
      idx if_do: {
        line = margs first selector() line
        target = method_name: margs
        (margs size - idx) times: |pos| {
          required = margs from: 0 to: (idx + pos)
          default = margs from: (idx+pos) to: -1
          params = required map: 'variable . + $ default map: 'default
          forward = AST MessageSend new: (AST Identifier from: target line: line) \
                                    to:  (AST Self new: line)                     \
                                    args:(AST MessageArgs new: params line: line) \
                                    line: line
          doc = AST StringLiteral new: ("Forward to message " ++ target) line: line
          body = AST ExpressionList new: [doc, forward] line: line
          block call: [required, body]
        }
      }
    }

    def ast: line oper: op arg: arg body: body access: access ('public) owner: owner (nil) {
      margs = ast: line param: op var: arg
      ast: line method: margs body: body access: access owner: owner
    }

    def ast: line method: margs body: body access: access ('public) owner: owner (nil) {
      margs is_a?(AST Identifier) . if_do: {
        args = AST MethodArgs new: [] line: line
        owner if_do: {
          AST SingletonMethodDef new: line name: margs args: args \
                                 body: body access: access owner: owner
        } else: {
          AST MethodDef new: line name: margs args: args body: body access: access
        }
      } else: {
        name = method_name: margs
        name = AST Identifier new: name line: line
        args = margs map() |m| { m variable() string }
        args = AST MethodArgs new: args line: line
        owner if_do: {
          AST SingletonMethodDef new: line name: name args: args \
                                 body: body access: access owner: owner
        } else: {
          AST MethodDef new: line name: name args: args body: body access: access
        }
      }
    }

    def ast: line method: margs expand: body access: access ('public) owner: owner (nil) {
      defs = []
      method: margs delegators: |sel fwd| {
        defs << $ ast: line method: sel body: fwd access: access owner: owner
      }
      defs << $ ast: line method: margs body: body access: access owner: owner
      AST ExpressionList new: line list: defs
    }

    def ast: line block: body {
       AST BlockLiteral new: line args: nil body: body
    }

  }
}
