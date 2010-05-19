#include "includes.h"

namespace fancy {
  namespace bootstrap {

    /**
     * Block instance methods
     */
    METHOD(method_Block_call);
    METHOD(method_Block_call_with_arg);
    METHOD(method_Block_while_true);
    METHOD(method_Block_if);
    METHOD(method_Block_unless);
    METHOD(method_Block_arguments);
    METHOD(method_Block_argcount);

    void init_block_class()
    {  
      BlockClass->def_method("call",
                             new NativeMethod("call",
                                              "Calls (evaluates) the Block with no arguments.",
                                              method_Block_call));

      BlockClass->def_method("call:",
                             new NativeMethod("call:",
                                              "Calls (evaluates) the Block with the given arguments (single value or Array).",
                                              method_Block_call_with_arg));

      BlockClass->def_method("while_true:",
                             new NativeMethod("while_true:",
                                              "Calls the given Block while this one evaluates to non-nil.",
                                              method_Block_while_true));

      BlockClass->def_method("if:",
                             new NativeMethod("if:",
                                              "Evaluates the Block if the given argument is non-nil.",
                                              method_Block_if));

      BlockClass->def_method("unless:",
                             new NativeMethod("unless:",
                                              "Evaluates the Block if the given argument is nil.",
                                              method_Block_unless));

      BlockClass->def_method("arguments",
                             new NativeMethod("arguments",
                                              "Returns an Array of the argument names.",
                                              method_Block_arguments));

      BlockClass->def_method("argcount",
                             new NativeMethod("argcount",
                                              "Returns the amount of arguments, the Block expects to be called with.",
                                              method_Block_argcount));
    }


    /**
     * Block instance methods
     */

    FancyObject_p method_Block_call(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      if(argc != 0) {
        errorln("Block#call got more than 0 arguments!");
      } else {
        Block_p block = dynamic_cast<Block_p>(self);
        return block->call(self, scope);
      }
      return nil;
    }

    FancyObject_p method_Block_call_with_arg(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
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

    FancyObject_p method_Block_while_true(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
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

    FancyObject_p method_Block_if(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
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

    FancyObject_p method_Block_unless(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
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

    FancyObject_p method_Block_arguments(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      Block_p block = dynamic_cast<Block_p>(self);
      return new Array(block->args());
    }

    FancyObject_p method_Block_argcount(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      Block_p block = dynamic_cast<Block_p>(self);
      return Number::from_int(block->argcount());
    }

  }
}
