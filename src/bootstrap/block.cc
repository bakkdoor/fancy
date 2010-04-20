#include "includes.h"

namespace fancy {
  namespace bootstrap {

    void init_block_class()
    {  
      BlockClass->def_method("call", new NativeMethod("call", method_Block_call));
      BlockClass->def_method("call:", new NativeMethod("call:", method_Block_call_with_arg, 1));
      BlockClass->def_method("while_true:", new NativeMethod("while_true:", method_Block_while_true, 1));
      BlockClass->def_method("if:", new NativeMethod("if:", method_Block_if, 1));
      BlockClass->def_method("unless:", new NativeMethod("unless:", method_Block_unless, 1));
      BlockClass->def_method("arguments", new NativeMethod("arguments", method_Block_arguments));
      BlockClass->def_method("argcount", new NativeMethod("argcount", method_Block_argcount));
    }


    /**
     * Block instance methods
     */

    FancyObject_p method_Block_call(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      if(args.size() != 0) {
        errorln("Block#call got more than 0 arguments!");
      } else {
        Block_p block = dynamic_cast<Block_p>(self);
        return block->call(self, scope);
      }
      return nil;
    }

    FancyObject_p method_Block_call_with_arg(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("Block#call:", 1);
      Block_p block = dynamic_cast<Block_p>(self);
      FancyObject_p first_arg = args.front();
      if(IS_ARRAY(first_arg)) {
        Array_p args_array = dynamic_cast<Array_p>(first_arg);
        return block->call(self, args_array->to_list(), scope);
      } else {
        return block->call(self, list<FancyObject_p>(1, first_arg), scope);
      }
    }

    FancyObject_p method_Block_while_true(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("Block#while_true:", 1);
      FancyObject_p first_arg = args.front();
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

    FancyObject_p method_Block_if(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("Block#if:", 1);
      FancyObject_p first_arg = args.front();
      if(first_arg != nil) {
        Block_p block = dynamic_cast<Block_p>(self);
        return block->call(self, scope);
      } else {
        return nil;
      }
    }

    FancyObject_p method_Block_unless(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("Block#unless:", 1);
      FancyObject_p first_arg = args.front();
      if(first_arg == nil) {
        Block_p block = dynamic_cast<Block_p>(self);
        return block->call(self, scope);
      } else {
        return nil;
      }
    }

    FancyObject_p method_Block_arguments(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      Block_p block = dynamic_cast<Block_p>(self);
      return new Array(block->args());
    }

    FancyObject_p method_Block_argcount(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      Block_p block = dynamic_cast<Block_p>(self);
      return Number::from_int(block->argcount());
    }

  }
}
