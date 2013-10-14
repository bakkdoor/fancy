class Fancy
  class AST
    [ :Node, :Self, :FixnumLiteral, :NumberLiteral, :RegexLiteral, :ScopedConstant ].
      each { |n| const_set(n, Rubinius::ToolSet.current::TS::AST.const_get(n)) }
  end
end

class Rubinius::ToolSet.current::TS::AST::Self
  def method_name(receiver = nil, with_ruby_args = false)
    if with_ruby_args
      "self".to_sym
    else
      ":self".to_sym
    end
  end
end
