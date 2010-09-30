module Fancy
  module AST

    class Node
      attr_accessor :name, :line

      def self.name(name)
        Nodes[name] = self
      end

      def pos(g)
        g.set_line(@line || 1) 
      end

      def new_block_generator(g, arguments)
        blk = g.class.new
        blk.name = g.state.name || :__block__
        blk.file = g.file
        blk.for_block = true

        blk.required_args = arguments.required_args
        blk.total_args = arguments.total_args

        blk
      end

      def new_generator(g, name, arguments=nil)
        meth = g.class.new
        meth.name = name
        meth.file = g.file

        if arguments
          meth.required_args = arguments.required_args
          meth.total_args = arguments.total_args
          meth.splat_index = arguments.splat_index
        end

        meth
      end


      def defined(g)
        g.push_rubinius
        g.push_scope
        g.send :active_path, 0
        g.push @line
        g.send :unrecognized_defined, 2
        g.pop
        g.push :nil
      end

      def value_defined(g, f)
        bytecode(g)
      end

      def visit(arg=true, &block)
        instance_variables.each do |name|
          child = instance_variable_get name
          next unless child.kind_of? Node
          next unless ch_arg = block.call(arg, child)
          child.visit(ch_arg, &block)
        end
      end

      def ascii_graph
        AsciiGrapher.new(self).print
      end

      # Called if used as the lhs of an ||=. Expected to yield if the
      # value was not found, so the bytecode for it to be emitted.
      def or_bytecode(g)
        found = g.new_label
        bytecode(g)
        g.dup
        g.git found
        g.pop
        yield
        found.set!
      end
    end

  end
end
