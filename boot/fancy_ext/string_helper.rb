class Fancy
  class AST
    class StringHelper
      def self.unescape_string(str)
        str.gsub("\\r", "\r").gsub("\\t", "\t").gsub("\\n", "\n").gsub("\\v", "\v").gsub("\\b", "\b").
          gsub("\\f", "\f").gsub("\\a", "\a").gsub("\\\\", "\\").gsub("\\?", "\?").gsub("\\'", "\'").gsub('\\"', '\"').gsub("\\\"", "\"")
      end
    end
  end
end
