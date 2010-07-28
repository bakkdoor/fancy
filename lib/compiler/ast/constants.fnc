def class Rubinius {
  def class AST {
    def class ScopedConstant : Node {
      self read_write_slots: [:line, :parent, :name];

      def self line: line parent: parent name: name {
        sc = ScopedConstant new;
        sc line: line;
        sc parent: parent;
        sc name: name;
        sc
      }

      def bytecode: g {
        self pos: g;

        @parent bytecode: g;
        g find_const: @name
      }

      def assign_bytecode: g {
        self pos: g;

        @parent bytecode: g;
        g push_literal: @name
      }

      def masgn_bytecode: g {
        self pos: g;

        @parent bytecode: g;
        g swap;
        g push_literal: @name
      }

      def defined: g {
        f = g new_label;
        done = g new_label;

        self value_defined: g label: f const_missing: false;

        g pop;
        g push_literal: "constant";
        g goto: done;

        f set!;
        g push: :nil;

        done set!
      }

      def value_defined: g label: f {
        self value_defined: g label: f const_missing: true
      }

      def value_defined: g label: f const_missing: cm{
        # Save the current exception into a stack local
        g push_exception_state;
        outer_exc_state = g new_stack_local;
        g set_stack_local: outer_exc_state;
        g pop;

        ex = g new_label;
        ok = g new_label;
        g setup_unwind: ex type: RescueType;

        @parent bytecode: g;
        g push_literal: @name;
        g push: $ cm if_true: { :true } else: { :false };
        g invoke_primitive: :vm_const_defined_under arg2: 3;

        g pop_unwind;
        g goto: ok;

        ex set!;
        g clear_exception;
        g push_stack_local: outer_exc_state;
        g restore_exception_state;
        g goto: f;

        ok set!
      }

      def to_sexp {
        [:colon2, @parent to_sexp, @name]
      }

      # TODO: translate this:
      # alias_method :assign_sexp, :to_sexp
    };

    def class ToplevelConstant : Node {
      self read_write_slots: [:line, :name];

      def self line: line name: name {
        tlc = ToplevelConstant new;
        tlc line: line;
        tlc name: name;
        tlc
      }

      def bytecode: g {
        self pos: g;

        g push_cpath_top;
        g find_const: @name
      }

      def assign_bytecode: g {
        self pos: g;

        g push_cpath_top;
        g push_literal: @name
      }

      def masgn_bytecode: g {
        self pos: g;

        g push_cpath_top;
        g swap;
        g push_literal: @name
      }

      def defined: g {
        f = g new_label;
        done = g new_label;

        self value_defined: g label: f;

        g pop;
        g push_literal: "constant";
        g goto: done;

        f set!;
        g push: :nil;

        done set!
      }

      def value_defined: g label: f {
        # Save the current exception into a stack local
        g push_exception_state;
        outer_exc_state = g new_stack_local;
        g set_stack_local: outer_exc_state;
        g pop;

        ex = g new_label;
        ok = g new_label;
        g setup_unwind: ex type: RescueType;

        g push_cpath_top;
        g push_literal: @name;
        g push: :false;
        g invoke_primitive: :vm_const_defined_under arg2: 3;

        g pop_unwind;
        g goto: ok;

        ex set!;
        g clear_exception;
        g push_stack_local: outer_exc_state;
        g restore_exception_state;
        g goto f;

        ok set!
      }

      def to_sexp {
        [:colon3, @name]
      }

      # TODO: translate this:
      # alias_method :assign_sexp, :to_sexp
    };

    def class ConstantAccess : Node {
      self read_write_slots: [:line, :name];

      def self line: line name: name {
        ca = ConstantAccess new;
        ca line: line;
        ca name: name;
        ca
      }

      def bytecode: g {
        self pos: g;

        g push_const: @name
      }

      def assign_bytecode: g {
        self pos: g;

        g push_scope;
        g push_literal: @name
      }

      def masgn_bytecode: g {
        self pos: g;

        g push_scope;
        g swap;
        g push_literal: @name
      }

      def defined: g {
        f = g new_label;
        done = g new_label;

        self value_defined: g label: f;

        g pop;
        g push_literal: "constant";
        g goto: done;

        f set!;
        g push: :nil;

        done set!
      }

      def value_defined: g label: f {
        # Save the current exception into a stack local
        g push_exception_state;
        outer_exc_state = g new_stack_local;
        g set_stack_local: outer_exc_state;
        g pop;

        ex = g new_label;
        ok = g new_label:
        g setup_unwind: ex type: RescueType;

        g push_literal: @name;
        g invoke_primitive: :vm_const_defined arg2: 1;

        g pop_unwind;
        g goto: ok;

        ex set!;
        g clear_exception;
        g push_stack_local: outer_exc_state;
        g restore_exception_state;
        g goto: f;

        ok set!
      }

      def assign_sexp {
        @name
      }

      def to_sexp {
        [:const, @name]
      }
    };

    def class ConstantAssignment : Node {
      self read_write_slots: [:line, :expr, :constant, :value];

      def self line: line expr: expr value: value {
        ca = ConstantAssignment new;
        ca line: line;
        ca value: value;

        expr is_a?: Symbol . if_true: {
          constant = ConstantAccess line: line expr: expr
        } else: {
          constant = expr
        };

        ca constant: constant;
        ca
      }

      def masgn_bytecode: g {
        @constant masgn_bytecode: g;
        g swap;
        g send: :const_set params: [2]
      }

      def bytecode: g {
        self pos: g;

        g state masgn? if_do: {
          self masgn_bytecode: g
        } else: {
          @constant assign_bytecode: g;
          @value bytecode: g;
          g send: :const_set params: [2]
        }
      }

      def to_sexp {
        sexp = [:cdecl, @constant assign_sexp];
        { sexp << (@value to_sexp) } if: @value;
        sexp
      }
    }
  }
}
