class Fancy AST {
  class Match : Node {
    def initialize: @line expr: @expr body: @clauses {
    }

    def bytecode: g set_match_args: clause {
      "Generates bytecode for setting match clause arguments, if needed"

      g dup()
      skip_create_locals_label = g new_label()
      g gif(skip_create_locals_label)

      # if match_arg is given, get a localvar slot and set the
      # result of the === call to it
      if: (clause match_args first) then: |marg| {
        match_arg_var = g state() scope() new_local(marg)
        @match_arg_vars << match_arg_var
        g set_local(match_arg_var slot())
      }

      # for any remaining match arguments, set their values to
      # whatever matcher[idx] returns (should be the matched data)
      clause match_args rest each_with_index: |match_arg idx| {
        idx = idx + 1 # we only want from index 1 onwards
        g dup() # dup the matcher object
        match_arg_var = g state() scope() new_local(match_arg)
        @match_arg_vars << match_arg_var
        FixnumLiteral new: @line value: idx . bytecode: g
        g send('at:, 1)
        g set_local(match_arg_var slot())
        g pop()
      }

      skip_create_locals_label set!()
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

      @match_arg_vars = []

      @clauses each_with_index: |c i| {
        g dup() # save the @expr since we need to reuse it
        c expr bytecode: g
        g swap()
        g send(':===, 1)
        bytecode: g set_match_args: c
        g git(clause_labels[i])
      }
      g pop()
      g push_nil()
      g goto(end_label)

      clause_labels each_with_index: |label i| {
        label set!()
        g pop()

        # set any new locals created in the match clause body to nil afterwards
        # so they're only visible in the current clause body.
        detected_locals = g detected_locals()

        @clauses[i] body bytecode: g

        new_detected_locals = g detected_locals()
        new_detected_locals - detected_locals times: |i| {
          g push_nil()
          g set_local(i + detected_locals)
          g pop()
        }

        # set match_arg locals slot to nil, so they're only visible
        # within the match clause body
        @match_arg_vars each: |marg_var| {
          g push_nil()
          g set_local(marg_var slot())
          g pop()
        }

        g goto(end_label)
      }

      end_label set!()
    }
  }

  class MatchClause : Node {
    read_slots: ['expr, 'body, 'match_args]

    def initialize: @line expr: @expr body: @body args: @match_args {
      if: (@expr kind_of?: Identifier) then: {
        if: (@expr string == "_") then: {
          @expr = Identifier from: "Object" line: @line
        }
      }
      @match_args = @match_args map: 'name
    }
  }
}
