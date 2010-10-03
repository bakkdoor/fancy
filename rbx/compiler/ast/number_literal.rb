module Fancy
  module AST
    Nodes[:int_lit] = Rubinius::AST::FixnumLiteral
    Nodes[:double_lit] = Rubinius::AST::FloatLiteral
  end
end
