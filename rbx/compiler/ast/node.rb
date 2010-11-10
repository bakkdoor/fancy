module Fancy
  module AST
    %w{
      Node Self ScopedConstant
      FixnumLiteral RegexLiteral NumberLiteral
    }.each { |n| const_set(n, Rubinius::AST.const_get(n)) }
  end
end
