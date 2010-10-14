## This file expects rbx/compiler/ast has been loaded


module Fancy

  # This module has methods that can be used as callbacks from
  # the parser, so that we can have a relatively simple fancy.y
  # For example, when the parser sees a literal (or any other node)
  # it just calls methods defined here. that create actual
  # Fancy::AST nodes, returning them to the parser to be stored on
  # $$
  module Parser

    # Invoked by the parser when it has seen an string
    def create_integer(line, token)

    end

  end

end
