module Fancy
  module AST

    class Match < Node
      def initialize(line, expr, clauses)
        super(line)
        @expr = expr
        @clauses = clauses
      end

      def bytecode(g)
        pos(g)

        # create labels for each clause body.
        clause_labels = []
        @clauses.size.times do
          clause_labels << g.new_label
        end
        end_label = g.new_label

        # ok, let's emit the bytecode
        @expr.bytecode(g)

        @clauses.each_with_index do |c, i|
          g.dup # save the @expr since we need to reuse it
          c.match_expr.bytecode(g)
          g.swap
          g.send :":===", 1

          # if match_arg is given, get a localvar slot and set the
          # result of the === call to it
          if c.match_arg
            @match_arg_var = g.state.scope.new_local c.match_arg
            g.set_local @match_arg_var.slot
          end

          g.git clause_labels[i]
        end
        g.pop
        g.push_nil
        g.goto end_label

        clause_labels.each_with_index do |label, i|
          label.set!
          g.pop
          @clauses[i].val_expr.bytecode(g)

          # set match_arg local slot to nil, so it's only visible
          # within the case body
          if @match_arg_var
            g.push_nil
            g.set_local @match_arg_var.slot
            g.pop
          end

          g.goto end_label
        end

        end_label.set!
      end
    end

    class MatchClause < Node
      attr_reader :match_expr, :val_expr, :match_arg
      def initialize(line, match_expr, val_expr, match_arg)
        super(line)
        if match_expr.kind_of?(Fancy::AST::Identifier) && match_expr.identifier == "_"
          match_expr = Fancy::AST::Identifier.new(match_expr.line, "Object")
        end
        @match_expr = match_expr
        @val_expr = val_expr

        if match_arg
          # use name so we get the identifier as a symbol
          @match_arg = match_arg.name
        end
      end
    end

  end
end
