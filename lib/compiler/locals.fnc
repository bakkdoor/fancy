def class Rubinius {
  def class Compiler {
    def class LocalVariables {
      def variables {
        @variables = @variables or_take: <[]>
      }

      def local_count {
        variables size
      }

      def local_names {
        names = [];
        eval_names = [];
        variables each_pair: |name var| {
          var kind_of?: EvalLocalVariable . if_true: {
            eval_names << name
          } else: {
            names at: (var slot) put: name
          }
        };
        names = names + eval_names
      }

      def allocate_slot {
        variables size
      }
    }

    def class LocalVariable {
      self read_slots: [:slot];

      def initialize: slot {
        @slot = slot
      }

      def reference {
        LocalReference new: @slot
      }

      def nested_reference {
        NestedLocalReference new: @slot
      }
    }

    def class NestedLocalVariable {
      self read_slots: [:depth, :slot];

      def self with_depth: depth slot: slot {
        NestedLocalVariable new: [depth, slot]
      }

      def initialize: depth_and_slot {
        @depth = depth_and_slot first;
        @slot = depth_and_slot second
      }

      def reference {
        NestedLocalReference new: [@slot, @depth]
      }

      # self alias_method: :nested_reference with: :reference
    };

    def class EvalLocalVariable {
      self read_slots: [:name];

      def initialize: name {
        @name = name
      }

      def reference {
        EvalLocalReference new: @name
      }

      # self alias_method: :nested_reference with: :reference
    };

    def class LocalReference {
      self read_slots: [:slot];

      def initialize: slot {
        @slot = slot
      }

      def get_bytecode: g {
        g push_local: @slot
      }

      def set_bytecode: g {
        g set_local: @slot
      }
    }

    def class NestedLocalReference {
      self read_write_slots: [:depth];
      self read_slots: [:slot];

      def self with_slot: slot depth: depth {
        nlr = NestedLocalReference new: slot;
        nlr depth: depth
      }

      def initialize: slot {
        @slot = slot;
        @depth = 0
      }

      def get_bytecode: g {
        @depth == 0 . if_true: {
          g push_local: @slot
        } else: {
          g push_local_depth: [@depth, @slot]
        }
      }

      def set_bytecode: g {
        @depth == 0 . if_true: {
          g set_local: @slot
        } else: {
          g set_local_depth: [@depth, @slot]
        }
      }
    }

    def class EvalLocalReference {

      # Ignored, but simplifies duck-typing references
      self read_write_slots: [:depth];

      def initialize: name {
        @name = name;
        @depth = 0
      }

      def get_bytecode: g {
        g push_variables;
        g push_literal: @name;
        g send: :get_eval_local params: [1, nil] # TODO: fix this line!
      }

      def set_bytecode: g {
        g push_variables;
        g swap;
        g push_literal: @name;
        g swap;
        g send: :set_eval_local params: [2, nil]
      }
    }
  }
}
