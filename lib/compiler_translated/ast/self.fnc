def class Rubinius {
  def class AST {
    def class Self : Node {
      def bytecode: g {
        self pos: g;

        g push: :self
      }

      def defined: g {
        g push_literal: "self"
      }

      def value_defined: g label: f {
        g push: :self
      }

      def to_sexp {
        [:self]
      }
    }
  }
}
