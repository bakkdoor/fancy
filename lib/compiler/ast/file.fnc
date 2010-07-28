def class Rubinius {
  def class AST {
    def class File : Node {
      def bytecode: g {
        self pos: g;

        g push_scope;
        g send: :active_path params: [0]
      }

      def to_sexp {
        [:file]
      }
    }
  }
}
