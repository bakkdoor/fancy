def class Rubinius {
  def class AST {
    def class EndData : Node {
      self read_write_slots: [:offset, :body, :data];

      def self offset: offset body: body {
        ed = EndData new;
        ed offset: offset;
        ed body: body;
        ed
      }

      # When a script includes __END__, Ruby makes the data after it
      # available as an IO instance via the DATA constant. Since code
      # in the toplevel can access this constant, we have to set it up
      # before any other code runs. This AST node wraps the top node
      # returned by the file parser.
      def bytecode: g {
        g push_rubinius;
        g push_scope;
        g send: :data_path params: [0];
        g push_literal: @offset;
        g send: :set_data params: [2];
        g pop;

        @body bytecode: g
      }
    }
  }
}
