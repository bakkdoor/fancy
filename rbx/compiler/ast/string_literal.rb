module Fancy
  module AST
    class StringLiteral < Rubinius::AST::StringLiteral
      def initialize(line, str)
        super(line, unescape_chars(str))
      end

      def unescape_chars(str)
        str.gsub("\\r", "\r").gsub("\\t", "\t").gsub("\\n", "\n").gsub("\\v", "\v").gsub("\\b", "\b").
          gsub("\\f", "\f").gsub("\\a", "\a").gsub("\\\\", "\\").gsub("\\?", "\?").gsub("\\'", "\'").gsub('\\"', '\"').gsub("\\\"", "\"")
      end
    end
  end
end
