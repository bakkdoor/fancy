class Fancy AST {
  class Script : Node {
    read_slots: ('file, 'line, 'body)
    @@stack = []

    def push_script {
      @@stack push(self)
    }

    def pop_script {
      @@stack pop()
    }

    def self current {
      @@stack last()
    }

    def initialize: @line file: @file body: @body

    def bytecode: g {
      pos(g)
      try {
        push_script

        # docs, code = body.expressions.partition do |s|
        #   s.kind_of?(Rubinius::ToolSet::Runtime::AST::StringLiteral)
        # end

        # if code.empty?
        #   # only literal string found, we have to evaluate to it, not
        #   # use as documentation.
        #   docs, code = [], docs
        # end

        # code.each { |c| c.bytecode(g) }

        @body bytecode: g

        # the docs array has top-level expressions that are
        # simply string literals, we can use them for file-level
        # documentation.
        # TODO: implement file documentation here.
      } finally {
        pop_script
      }
    }
  }
}
