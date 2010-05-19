#include "includes.h"

namespace fancy {
  namespace bootstrap {

    /**
     * Block instance methods
     */
    METHOD(Block__call);
    METHOD(Block__call_with_arg);
    METHOD(Block__while_true);
    METHOD(Block__if);
    METHOD(Block__unless);
    METHOD(Block__arguments);
    METHOD(Block__argcount);

    void init_block_class()
    {  
      BlockClass->def_method("call",
                             new NativeMethod("call",
                                              "Calls (evaluates) the Block with no arguments.",
                                              Block__call));

      BlockClass->def_method("call:",
                             new NativeMethod("call:",
                                              "Calls (evaluates) the Block with the given arguments (single value or Array).",
                                              Block__call_with_arg));

      BlockClass->def_method("while_true:",
                             new NativeMethod("while_true:",
                                              "Calls the given Block while this one evaluates to non-nil.",
                                              Block__while_true));

      BlockClass->def_method("if:",
                             new NativeMethod("if:",
                                              "Evaluates the Block if the given argument is non-nil.",
                                              Block__if));

      BlockClass->def_method("unless:",
                             new NativeMethod("unless:",
                                              "Evaluates the Block if the given argument is nil.",
                                              Block__unless));

      BlockClass->def_method("arguments",
                             new NativeMethod("arguments",
                                              "Returns an Array of the argument names.",
                                              Block__arguments));

      BlockClass->def_method("argcount",
                             new NativeMethod("argcount",
                                              "Returns the amount of arguments, the Block expects to be called with.",
                                              Block__argcount));
    }


    /**
     * Block instance methods
     */

    METHOD(Block__call)
    {
      if(argc != 0) {
        errorln("Block#call got more than 0 arguments!");
      } else {
        Block_p block = dynamic_cast<Block_p>(self);
        return block->call(self, scope);
      }
      return nil;
    }

    METHOD(Block__call_with_arg)
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

    METHOD(Block__while_true)
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

    METHOD(Block__if)
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

    METHOD(Block__unless)
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

    METHOD(Block__arguments)
    {
      Block_p block = dynamic_cast<Block_p>(self);
      return new Array(block->args());
    }

    METHOD(Block__argcount)
    {
      Block_p block = dynamic_cast<Block_p>(self);
      return Number::from_int(block->argcount());
    }

  }
}
