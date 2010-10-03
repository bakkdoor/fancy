module Fancy
  module AST
    # Self node uses Rubinius' Self AST node in the background.
    Nodes[:self] = Rubinius::AST::Self
  end
end
