#include "includes.h"

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
                 "call:",
                 "Calls (evaluates) the Block with the given arguments (single value or Array).",
                 call_with_arg);

      DEF_METHOD(BlockClass,
                 "while_true:",
                 "Calls the given Block while this one evaluates to non-nil.",
                 while_true);

      DEF_METHOD(BlockClass,
                 "if:",
                 "Evaluates the Block if the given argument is non-nil.",
                 if);

      DEF_METHOD(BlockClass,
                 "unless:",
                 "Evaluates the Block if the given argument is nil.",
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
        Block_p block = dynamic_cast<Block_p>(self);
        return block->call(self, scope);
      }
      return nil;
    }

    METHOD(BlockClass, call_with_arg)
    {
      EXPECT_ARGS("Block#call:", 1);
      Block_p block = dynamic_cast<Block_p>(self);
      FancyObject_p first_arg = args[0];
      if(IS_ARRAY(first_arg)) {
        Array_p args_array = dynamic_cast<Array_p>(first_arg);
        int size = args_array->size();
        FancyObject_p *args_array_arr = new FancyObject_p[size];
        for(int i = 0; i < size; i++) {
          args_array_arr[i] = args_array->at(i);
        }
        FancyObject_p retval =  block->call(self, args_array_arr, size, scope);
        delete[] args_array_arr; // cleanup  before leave
        return retval;
      } else {
        FancyObject_p call_args[1] = { first_arg };
        return block->call(self, call_args, 1, scope);
      }
    }

    METHOD(BlockClass, while_true)
    {
      EXPECT_ARGS("Block#while_true:", 1);
      FancyObject_p first_arg = args[0];
      if(IS_BLOCK(first_arg)) {
        Block_p while_block = dynamic_cast<Block_p>(self);
        Block_p then_block = dynamic_cast<Block_p>(first_arg);
        while(while_block->call(self, scope) != nil) {
          then_block->call(self, scope);
        }
        return nil;
      } else {
        return nil;
      }
    }

    METHOD(BlockClass, if)
    {
      EXPECT_ARGS("Block#if:", 1);
      FancyObject_p first_arg = args[0];
      if(first_arg != nil) {
        Block_p block = dynamic_cast<Block_p>(self);
        return block->call(self, scope);
      } else {
        return nil;
      }
    }

    METHOD(BlockClass, unless)
    {
      EXPECT_ARGS("Block#unless:", 1);
      FancyObject_p first_arg = args[0];
      if(first_arg == nil) {
        Block_p block = dynamic_cast<Block_p>(self);
        return block->call(self, scope);
      } else {
        return nil;
      }
    }

    METHOD(BlockClass, arguments)
    {
      Block_p block = dynamic_cast<Block_p>(self);
      return new Array(block->args());
    }

    METHOD(BlockClass, argcount)
    {
      Block_p block = dynamic_cast<Block_p>(self);
      return Number::from_int(block->argcount());
    }

  }
}
