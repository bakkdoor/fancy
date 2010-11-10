module Fancy
  module AST
    [ :Node, :Self, :FixnumLiteral, :NumberLiteral, :RegexLiteral, :ScopedConstant ].
      each { |n| const_set(n, Rubinius::AST.const_get(n)) }
  end
end
