def class AST {
  def class Identifier : Node {
    read_write_slots: ['name];
    @@name_conversions = <["||" => "or",
                          "&&" => "and",
                          "!=" => "not_equal",
                          "++" => "plusplus",
                          "class" => "_class"]>;

    def initialize: name {
      @name = name
    }

    def Identifier from_sexp: sexp {
      Identifier new: $ sexp second
    }

    def to_s {
      "<Identifier: '" ++ @name ++ "'>"
    }

    def to_ruby: out indent: ilvl {
      out print: $ " " * ilvl;
      out print: $ self rubyfy
    }

    def rubyfy {
      namespaced_parts = @name to_s split: "::";
      namespaced_parts = namespaced_parts map: |n| { n to_s split: ":" . select: |x| { x empty? not } . join: "___" };
      name = namespaced_parts join: "::";
      @@name_conversions[name] if_do: |new_val| {
        new_val
      } else: {
        name
      }
    }
  }
}
