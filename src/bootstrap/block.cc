#include "../../vendor/gc/include/gc.h"
#include "../../vendor/gc/include/gc_cpp.h"
#include "../../vendor/gc/include/gc_allocator.h"

#include "includes.h"

#include "../array.h"
#include "../number.h"
#include "../block.h"

namespace fancy {
  namespace bootstrap {

    /**
     * Block instance methods
     */

    void init_block_class()
    {
      DEF_METHOD(BlockClass,
                 "call",
                 "Calls (evaluates) the Block with no arguments.",
                 call);

      DEF_METHOD(BlockClass,
                 "call_in_scope_of:",
                 "Calls (evaluates) the Block with no arguments in scope of a given object (acting as self within the Block's body).",
                 call_in_scope_of);

      DEF_METHOD(BlockClass,
                 "call:",
                 "Calls (evaluates) the Block with the given arguments (single value or Array).",
                 call_with_arg);

      DEF_METHOD(BlockClass,
                 "call:in_scope_of:",
                 "Calls (evaluates) the Block with the given arguments (single value or Array) in scope of a given object (acting as self within the Block's body).",
                 call_with_arg_in_scope_of);

      DEF_METHOD(BlockClass,
                 "while_true:",
                 "Calls the given Block while this one evaluates to non-nil.\nExample:\n\
    x = 0;\n\
    { x < 10 } while_true: { x println; x = x + 1 }",
                 while_true);

      DEF_METHOD(BlockClass,
                 "if:",
                 "Evaluates the Block if the given argument is non-nil.\nExample:\n\
    { arr clone } if: (arr is_a?: Array)",
                 if);

      DEF_METHOD(BlockClass,
                 "unless:",
                 "Evaluates the Block if the given argument is nil.\nExample:\n\
    { arr clone } unless: (arr empty?)",
                 unless);

      DEF_METHOD(BlockClass,
                 "arguments",
                 "Returns an Array of the argument names.",
                 arguments);

      DEF_METHOD(BlockClass,
                 "argcount",
                 "Returns the amount of arguments, the Block expects to be called with.",
                 argcount);
    }


    /**
     * Block instance methods
     */

    METHOD(BlockClass, call)
    {
      if(argc != 0) {
        errorln("Block#call got more than 0 arguments!");
      } else {
        Block* block = dynamic_cast<Block*>(self);
        return block->call(self, scope, sender);
      }
      return nil;
    }

    METHOD(BlockClass, call_in_scope_of)
    {
      EXPECT_ARGS("Block#call_in_scope_of:", 1);
      Block* block = dynamic_cast<Block*>(self);
      bool override_self = block->override_self();
      block->override_self(true);
      FancyObject* retval = nil;
      try {
        retval = block->call(args[0], scope, sender);
      } catch(FancyObject* e) {
        block->override_self(override_self);
        throw e;
      }
      block->override_self(override_self);
      return retval;
    }

    METHOD(BlockClass, call_with_arg)
    {
      EXPECT_ARGS("Block#call:", 1);
      Block* block = dynamic_cast<Block*>(self);
      FancyObject* first_arg = args[0];
      if(IS_ARRAY(first_arg)) {
        Array* args_array = dynamic_cast<Array*>(first_arg);
        int size = args_array->size();
        FancyObject* *args_array_arr = new FancyObject*[size];
        for(int i = 0; i < size; i++) {
          args_array_arr[i] = args_array->at(i);
        }
        FancyObject* retval = block->call(self, args_array_arr, size, scope, sender);
        delete[] args_array_arr; // cleanup  before leave
        return retval;
      } else {
        FancyObject* call_args[1] = { first_arg };
        return block->call(self, call_args, 1, scope, sender);
      }
    }

    METHOD(BlockClass, call_with_arg_in_scope_of)
    {
      EXPECT_ARGS("Block#call:in_scope_of:", 2);
      Block* block = dynamic_cast<Block*>(self);
      FancyObject* first_arg = args[0];
      bool override_self = block->override_self();
      FancyObject* retval = nil;

      if(IS_ARRAY(first_arg)) {
        Array* args_array = dynamic_cast<Array*>(first_arg);
        int size = args_array->size();
        FancyObject* *args_array_arr = new FancyObject*[size];
        for(int i = 0; i < size; i++) {
          args_array_arr[i] = args_array->at(i);
        }

        try {
          block->override_self(true);
          retval = block->call(args[1], args_array_arr, size, scope, sender);
        } catch(FancyObject* e) {
          delete[] args_array_arr; // cleanup  before leave
          block->override_self(override_self);
          throw e;
        }

        delete[] args_array_arr; // cleanup  before leave
        block->override_self(override_self);
        return retval;
      } else {
        try {
          FancyObject* call_args[1] = { first_arg };
          block->override_self(true);
          retval = block->call(args[1], call_args, 1, scope, sender);
        } catch(FancyObject* e) {
          block->override_self(override_self);
          throw e;
        }
        block->override_self(override_self);
        return retval;
      }
    }

    METHOD(BlockClass, while_true)
    {
      EXPECT_ARGS("Block#while_true:", 1);
      FancyObject* first_arg = args[0];
      if(IS_BLOCK(first_arg)) {
        Block* while_block = dynamic_cast<Block*>(self);
        Block* then_block = dynamic_cast<Block*>(first_arg);
        while(while_block->call(self, scope, sender) != nil) {
          then_block->call(self, scope, sender);
        }
        return nil;
      } else {
        return nil;
      }
    }

    METHOD(BlockClass, if)
    {
      EXPECT_ARGS("Block#if:", 1);
      FancyObject* first_arg = args[0];
      if(first_arg != nil) {
        Block* block = dynamic_cast<Block*>(self);
        return block->call(self, scope, sender);
      } else {
        return nil;
      }
    }

    METHOD(BlockClass, unless)
    {
      EXPECT_ARGS("Block#unless:", 1);
      FancyObject* first_arg = args[0];
      if(first_arg == nil) {
        Block* block = dynamic_cast<Block*>(self);
        return block->call(self, scope, sender);
      } else {
        return nil;
      }
    }

    METHOD(BlockClass, arguments)
    {
      Block* block = dynamic_cast<Block*>(self);
      return new Array(block->args());
    }

    METHOD(BlockClass, argcount)
    {
      Block* block = dynamic_cast<Block*>(self);
      return Number::from_int(block->argcount());
    }

  }
}
