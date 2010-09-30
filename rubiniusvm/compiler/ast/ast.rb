module Fancy
  module AST
    Nodes = Hash.new
    
    # Converts a fancy sexp into fancy AST
    def self.from_sexp(sexp)
      name = sexp.first
      rest = sexp[1..-1]
      type = Nodes[name]
      raise "Unknown sexp type: #{name}" unless type
      body = rest.map { |e| if e.kind_of?(Array) then from_sexp(e) else e end }
      ast = type.new(*body)
      ast.name = name
      ast
    end
  end
end
