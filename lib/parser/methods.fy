require: "parse_error"

class Fancy {
  class Parser {
    SelectorVarDefault = Struct.new('selector, 'variable, 'default)
    SelectorValue = Struct new('selector, 'value)

    def self parse_file: filename line: line (1) {
      new: filename line: line . parse_file . script
    }

    def self parse_code: code file: filename line: line (1) {
      new: filename line: line . parse_string: code . script
    }

    read_write_slots: ['filename, 'line, 'script]

    def initialize: @filename line: @line { }

    def body: body {
      @script = AST Script new: @line file: @filename body: body
    }

    def ast: line exp_list: expr into: list (AST ExpressionList new: line) {
      { list expressions << expr } if: expr
      list
    }

    def ast: line identity: identity { identity }

    def ast: line concat: object into: ary ([]) {
      if: (object kind_of?(Array)) then: {
        ary concat(object)
      } else: {
        { ary << object } if: object
      }
      ary
    }

    def ast: line key: key value: value into: ary {
      ary if_nil: { ary = [] }
      ary << key
      ary << value
      ary
    }

    def ast: line fixnum: text base: base (10) {
      AST FixnumLiteral new: line value: (text to_i(base))
    }

    def ast: line number: text base: base (10) {
      AST NumberLiteral new: line value: (text to_f())
    }

    def ast: line symbol: text {
      str = text from: 1 to: -1
      AST SymbolLiteral new: line value: (str to_sym())
    }

    def ast: line regexp: text {
      regexp = text from: 1 to: -2
      AST RegexpLiteral new: line value: regexp
    }

    def ast: line string: text {
      str = text from: 1 to: -2
      str match: {
        # OK, I know this is ugly. But it works for now, so let's just go with it.
        # TODO: Clean this up or make it simpler...

        # this case handles string interpolation
        case: /(.*)#{(.*)}(.*)/ do: |matches| {
          prefix = matches[1]
          interpol_str = matches[2]
          suffix = matches[3]

          binding = AST MessageSend new: line message: (ast: line identifier: "binding") to: (AST Self new: line) args: (AST RubyArgs new: line args: [])
          evalstr = AST StringLiteral new: line value: interpol_str
          msg = ast: line identifier: "eval:binding:"
          binding_send = AST MessageSend new: line message: msg to: (ast: line identifier: "Fancy") \
                                         args: (AST MessageArgs new: line args: [evalstr, binding])

          prefix_str = ast: line string: (" " + prefix + " ") # hack, pre- & append " " since it gets removed
          suffix_str = ast: line string: (" " + suffix + " ")
          # create messagesend to concatenate:
          concat_ident = ast: line identifier: "++"
          concat_prefix_send = AST MessageSend new: line message: concat_ident to: prefix_str args: (AST MessageArgs new: line args: [binding_send])
          concat_suffix_send = AST MessageSend new: line message: concat_ident to: concat_prefix_send args: (AST MessageArgs new: line args: [suffix_str])

          concat_suffix_send # this shall get returned, yo
        }
        else: {
          AST StringLiteral new: line value: str
        }
      }
    }

    def ast: line multi_line_string: string {
      ast: line string: (string from: 2 to: -3)
    }

    def ast: line backtick: backtick_string {
      str = ast: line string: backtick_string
      selector = (ast: line identifier: "backtick:")
      args = AST MessageArgs new: line args: [str]
      AST MessageSend new: line message: selector to: (AST Self new: line) args: args
    }

    def ast: line array: expr_ary {
      AST ArrayLiteral new: line array: expr_ary
    }

    def ast: line hash: key_values {
      AST HashLiteral new: line entries: key_values
    }

    def ast: line tuple: expr_ary {
      if: (expr_ary size == 1) then: {
        expr_ary first
      } else: {
        AST TupleLiteral new: line entries: expr_ary
      }
    }

    def ast: line range: from to: to {
      AST RangeLiteral new: line from: from to: to
    }

    def ast: line identifier: text {
      AST Identifier from: text line: line filename: @filename
    }

    def ast: line constant: identifier parent: parent {
      AST NestedConstant new: line const: identifier parent: parent
    }

    def ast: line super_exp: text { AST Super new: line }

    def ast: line retry_exp: text { AST Retry new: line }

    def ast: line return_stmt: exp {
      { exp = AST NilLiteral new: exp } if: (exp nil?)
      AST Return new: line expr: exp
    }

    def ast: line return_local_stmt: exp {
      { exp = AST NilLiteral new: exp } if: (exp nil?)
      AST ReturnLocal new: line expr: exp
    }

    def ast: line assign: rvalue to: lvalue many: many (false) {
      ast = many if_true: { AST MultipleAssignment } else: { AST Assignment }
      ast new: line var: lvalue value: rvalue
    }

    def ast: line param: selector var: variable default: default (nil) {
      SelectorVarDefault new(selector, variable, default)
    }

    def ast: line send: selector arg: value ary: ary ([]) {
      ary << $ SelectorValue new(selector, value)
    }

    def ast: line oper: oper arg: arg to: receiver (AST Self new: line) {
      message = ast: line send: oper arg: arg
      ast: line send: message to: receiver
    }

    def ast: line oper: oper arg: arg1 arg: arg2 to: receiver (AST Self new: line) {
      m1 = SelectorValue new(oper, arg1)
      m2 = SelectorValue new(ast: line identifier: "", arg2)
      message = [m1, m2]
      ast: line send: message to: receiver
    }

    def ast: line future_oper: oper arg: arg to: receiver {
      oper_send = ast: line oper: oper arg: arg to: receiver
      AST FutureSend new: line message_send: oper_send
    }

    def ast: line async_oper: oper arg: arg to: receiver {
      oper_send = ast: line oper: oper arg: arg to: receiver
      AST AsyncSend new: line message_send: oper_send
    }

    def ast: line send: message to: receiver (AST Self new: line) ruby: ruby (nil) {
      args = ruby if_true: {
        unless: receiver do: {
          receiver = AST Self new: line
        }
        ruby
      } else: {
        AST MessageArgs new: line args: []
      }
      name = message
      if: (message kind_of?(String)) then: {
        name = AST Identifier from: message line: line
      }
      if: (message kind_of?(Array)) then: {
        name = message map: |m| { m selector() string } . join
        name = AST Identifier new: line string: name
        args = message map: |m| { m value() }
        args = AST MessageArgs new: line args: args
      }
      AST MessageSend new: line message: name to: receiver args: args
    }

    def ast: line future_send: message to: receiver ruby: ruby (nil) {
      message_send = ast: line send: message to: receiver ruby: ruby
      AST FutureSend new: line message_send: message_send
    }

    def ast: line async_send: message to: receiver ruby: ruby (nil) {
      message_send = ast: line send: message to: receiver ruby: ruby
      AST AsyncSend new: line message_send: message_send
    }

    def method_name: margs {
      margs map: |a| { a selector() string } . join("")
    }

    def method: margs delegators: block {
      idx = margs index() |m| { m default() != nil }
      if: idx then: {
        line = margs first selector() line
        target = method_name: margs
        (margs size - idx) times: |pos| {
          required = margs from: 0 to: (idx + pos - 1)
          default = margs from: (idx + pos) to: -1
          only_default_args = default size == (margs size)
          if: only_default_args then: {
            required = []
          }
          params = required map: |r| { r variable() } . + $ default map: |d| { d default() }

          forward = AST MessageSend new: line \
                                    message: (AST Identifier from: target line: line) \
                                    to:  (AST Self new: line)                     \
                                    args:(AST MessageArgs new: line args: params)

          doc = AST StringLiteral new: line value: ("Forward to message " ++ target)
          body = AST ExpressionList new: line  list: [doc, forward]

          # use base method name (e.g. "foo:" -> "foo") for the method to be generated
          # if there are no more arguments left (only default args left)
          if: only_default_args then: {
            required = AST Identifier from: (margs first selector() string from: 0 to: -2) line: line
          }

          block call: [required, body]
        }
      }
    }

    def ast: line oper: op arg: arg body: body access: access ('public) owner: owner (nil) {
      margs = [ast: line param: op var: arg]
      ast: line method: margs body: body access: access owner: owner
    }

    def ast: line oper: op arg: arg1 arg: arg2 body: body access: access ('public) owner: owner (nil) {
      margs = [SelectorVarDefault new(op, arg1, nil), SelectorVarDefault new(ast: line identifier: "", arg2, nil)]
      ast: line method: margs body: body access: access owner: owner
    }

    def ast: line method: margs body: body access: access ('public) owner: owner (nil) {
      if: (margs is_a?(AST Identifier)) then: {
        args = AST MethodArgs new: line args: []
        if: owner then: {
          AST SingletonMethodDef new: line name: margs args: args \
                                 body: body access: access owner: owner
        } else: {
          AST MethodDef new: line name: margs args: args body: body access: access
        }
      } else: {
        name = method_name: margs
        name = AST Identifier new: line string: name
        args = margs map() |m| { m variable() string }
        args = AST MethodArgs new: line args: args
        if: owner then: {
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
      args = AST BlockArgs new: line
      AST BlockLiteral new: line args: args body: body
    }

    def ast: line partial_block: body {
      gen_blockarg = AST Identifier generate: line
      args = AST BlockArgs new: line args: [gen_blockarg]
      AST BlockLiteral new: line args: args body: body partial: true
    }

    def ast: line block: body args: args {
      args = AST BlockArgs new: line args: args
      AST BlockLiteral new: line args: args body: body
    }

    def ast: line class: name parent: parent body: body (AST ExpressionList new: line) {
      AST ClassDef new: line name: name parent: parent body: body
    }

    def ast: line match_expr: expr body: match_body {
      AST Match new: line expr: expr body: match_body
    }

    def ast: line match_clause: expr body: body args: match_args ([]) {
      AST MatchClause new: line expr: expr body: body args: match_args
    }

    def ast: line ex_handler: expr_list cond: cond (AST Identifier from: "Object" line: line) var: var (nil) {
      AST ExceptionHandler new: line condition: cond var: var body: expr_list
    }

    def ast: line try_block: body ex_handlers: handlers finally_block: finaly (AST NilLiteral new: line) {
      AST TryCatch new: line body: body handlers: handlers ensure: finaly
    }

    def ast: line ruby_send: text {
      name = text from: 0 to: -2  # remove the open left paren
      ast: line identifier: name
    }

    def ast: line ruby_args: args block: block (nil) {
      { args = [] } unless: args
      AST RubyArgs new: line args: args block: block
    }

    def ast: line parse_error: text {
      ParseError new: line message: text filename: @filename . raise!
    }

    def ast: line file_error: text {
      ("File error '" ++ text ++ "' while trying to parse " ++ @filename) . raise!
    }
  }
}

