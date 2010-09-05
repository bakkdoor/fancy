##
# Used for the Rubinius::asm Compiler hook.

def class Rubinius {
  def class AST {
    def class Evaluator {
      self read_write_slots: [:self];

      # TODO: translate this:
      # def initialize(generator, names, arguments)
      #   @self = generator
      #   @locals = {}

      #   names.each_with_index do |name, index|
      #     set_local name, arguments[index]
      #   end
      # end

      def execute: node {
        node execute: self
      }

      def get_local: name {
        @locals[name]
      }

      def set_local: name value: value {
        @locals at: name put: value
      }
    }

    def class Container {
      def execute: e {
        @body execute: e;
        true
      }
    }

    def class TrueLiteral {
      def execute: e {
        true
      }
    }

    def class FalseLiteral {
      def execute: e {
        false
      }
    }

    def class NilLiteral {
      def execute: e {
        nil
      }
    }

    def class Self {
      def execute: e {
        e self
      }
    }

    def class And {
      def execute: e {
        (@left execute: e) and: (@right execute: e)
      }
    }

    def class Or {
      def execute: e {
        (@left execute: e) or: (@right execute: e)
      }
    }

    def class Not {
      def execute: e {
        @child execute: e . not
      }
    }

    def class Negate {
      def execute: e {
        (@child execute: e) * -1
      }
    }

    def class NumberLiteral {
      def execute: e {
        @value
      }
    }

    def class Literal {
      def execute: e {
        @value
      }
    }

    def class RegexLiteral {
      def execute: e {
        # ::Regexp.new(@source, @options)
      }
    }

    def class StringLiteral {
      def execute: e {
        @string dup
      }
    }

    def class DynamicString {
      def execute: e {
        str = @string dup;
        @body each: |x| {
          str << (x execute: e)
        };

        str
      }
    }

    def class DynamicRegex {
      def execute: e {
        # ::Regexp.new super(e)
      }
    }

    def class DynamicOnceRegex {
      def execute: e {
        @value = @value or_take: (super execute: e)
      }
    }

    def class If {
      def execute: e {
        @condition execute: e . if_do: {
          { @then execute: e } if: @then
        } else: {
          { @else execute: e } if: @else
        }
      }
    }

    def class While {
      def execute: e {
        @check_first if_do: {
          { @condition.execute: e } while_true: {
            @body execute: e
          }
        } else: {
          {
            @body execute: e
          } while: { @condition execute: e }
        }
      }
    }

    def class Until {
      def execute: e {
        @check_first if_do: {
          { @condition execute: e } while_false: {
            @body execute: e
          }
        } else: {
          {
            @body execute: e
          } until: { @condition execute: e }
        }
      }
    }

    def class Block {
      def execute: e {
        val = nil;
        @array.each: |x| {
          val = x execute: e
        };

        val
      }
    }

    def class LocalVariableAccess {
      def execute: e {
        e get_local: @name
      }
    }

    def class LocalVariableAssignment {
      def execute: e {
        e set_local: @name value: (@value execute: e)
      }
    }

    def class ArrayLiteral {
      def execute: e {
        @body map: |x| { x execute: e }
      }
    }

    def class EmptyArray {
      def execute: e {
        []
      }
    }

    def class HashLiteral {
      def execute: e {
        args = @array map: |x| { x execute: e };
        # Hash[*args]
        Hash from_array: args
      }
    }

    def class SymbolLiteral {
      def execute: e {
        @value
      }
    }

    def class InstanceVariableAccess {
      def execute: e {
        e self instance_variable_get: @name
      }
    }

    def class InstanceVariableAssignment {
      def execute: e {
        e self instance_variable_set: @name value: (@value execute: e)
      }
    }

    def class GlobalVariableAccess {
      def execute: e {
        # TODO: translate this:
        # ::Rubinius::Globals[@name]
      }
    }

    def class GlobalVariableAssignment {
      def execute: e {
        # TODO: translate this:
        # ::Rubinius::Globals[@name] = @value.execute(e)
      }
    }

    def class ConstantAccess {
      def execute: e {
        Object const_get: @name
      }
    }

    def class ScopedConstant {
      def execute: e {
        parent = @parent execute: e;
        parent const_get: @name
      }
    }

    def class ToplevelConstant {
      def execute: e {
        Object const_get: @name
      }
    }

    def class Send {
      def execute_receiver: e {
        (@receiver kind_of?: Self) if_true: {
          e self
        } else: {
          @receiver execute: e
        }
      }

      def execute: e {
        receiver = self execute_receiver: e;

        receiver.__send__: @name
      }
    }

    def class SendWithArguments {
      def execute: e {
        arguments = @arguments execute: e;
        receiver = self execute_receiver: e;

        receiver.__send__: @name arguments: arguments
      }
    }

    def class ActualArguments {
      def execute: e {
        array = @array map: |x| { x execute: e };
        array << ({ @splat execute} if: (@splat kind_of?: SplatValue));
        array
      }
    }

    def class Yield {
      def execute: e {
        # TODO: translate this:
        # e.block.call(*@arguments.execute(e))
      }
    }

    def class ExecuteString {
      def execute: e {
        # `#{@string.execute(e)}`
        System do: (@string execute: e)
      }
    }

    def class ToString {
      def execute: e {
        @child execute: e . to_s
      }
    }

    def class DynamicExecuteString {
      def execute: e {
        # `#{super(e)}`
        System do: (super execute: e)
      }
    }
  }
}
