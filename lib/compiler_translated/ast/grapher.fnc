def class Rubinius {
  def class AST {
    def class AsciiGrapher {
      def initialize: ast {
        @ast = ast
      }

      def print {
        self graph_node: @ast
      }

      def indented_print: level value: value {
        (" " * level) ++ value println
      }

      def print_node: node level: level {
        name = node class to_s split: "::" . last;
        self indented_print: level value: name
      }

      def graph_node: node {
        self graph_node: node level: 0
      }

      def graph_node: node level: level {
        self print_node: node level: level;
        level = level + 2;

        nodes = [];
        node instance_variables each: |v| {
          { self next } if: (v == "@compiler");

          value = node instance_variable_get: v;

          # lame, yes. remove when Node doesn't have @body by default
          { next } if: ((v == "@body") and: (value nil?) and: ((v respond_to?: :body=) not));

          value is_a?: Node . if_true: {
            nodes << [v, value]
          } else: {
            self graph_value: v value: value level: level
          }
        };

        nodes each: |name, node| {
          (" " * level) ++ name ++ ": \\" println;
          self graph_node: node level: level
        }
      }

      def graph_simple: name value: value level: level {
        (" " * level) ++ name ++ ": " ++ value println
      }

      def graph_value: name value: value level: level {
        # TODO: translate this:
      #   case value
      #   when NilClass, String
      #     graph_simple name, value.inspect, level
      #   when TrueClass, FalseClass, Symbol, Fixnum
      #     graph_simple name, value, level
      #   when Array
      #     puts "#{" " * level}#{name}: \\"
      #     nodes = []
      #     value.each do |v|
      #       if v.kind_of? Node
      #         nodes << v
      #       else
      #         graph_value "-", v, level + 2
      #       end
      #     end

      #     nodes.each { |n| graph_node n, level + 2 }
      #   else
      #     graph_simple name, value.class, level
      #   end
      # end
      }
    }
  }
}
