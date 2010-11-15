class Fancy AST {

  class Match : Node {
    def initialize: @line expr: @expr body: @clauses {
    }


    def bytecode: g {
      pos(g)

      # create labels for each clause body.
      clause_labels = []
      @clauses size times: {
        clause_labels << (g new_label())
      }
      end_label = g new_label()

      # ok, let's emit the bytecode
      @expr bytecode: g

      @clauses each_with_index: |c i| {
        g dup() # save the @expr since we need to reuse it
        c expr bytecode: g
        g swap()
        g send(':===, 1)

        # if match_arg is given, get a localvar slot and set the
        # result of the === call to it
        c match_arg if_do: {
          @match_arg_var = g state() scope() new_local(c match_arg)
          g set_local(@match_arg_var slot())
        }

        g git(clause_labels[i])
      }
      g pop()
      g push_nil()
      g goto(end_label)

      clause_labels each_with_index: |label i| {
        label set!()
        g pop()
        @clauses[i] body bytecode: g

        # set match_arg local slot to nil, so it's only visible
        # within the case body
        @match_arg_var if_do: {
          g push_nil()
          g set_local(@match_arg_var slot())
          g pop()
        }

        g goto(end_label)
      }

      end_label set!()
    }
  }

  class MatchClause : Node {
    read_slots: ['expr, 'body, 'match_arg]
    def initialize: @line expr: @expr body: @body arg: @match_arg {
      @expr kind_of?: Identifier . if_true: {
        @expr string == "_" if_true: {
          @expr = Identifier from: "Object" line: @line
        }
      }
      @match_arg if_do: {
        @match_arg = @match_arg name
      }
    }
  }

}
