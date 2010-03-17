#include "includes.h"

void init_block_class()
{  
  BlockClass->def_method("call", new NativeMethod("call", method_Block_call));
  BlockClass->def_method("call:", new NativeMethod("call:", method_Block_call_with_arg));
  BlockClass->def_method("while_true:", new NativeMethod("while_true:", method_Block_while_true));
}


/**
 * Block instance methods
 */

FancyObject_p method_Block_call(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  if(args.size() != 0) {
    errorln("Block#call got more than 0 arguments!");
  } else {
    Block_p block = dynamic_cast<Block_p>(self->native_value());
    return block->call(self, args, scope);
  }
  return nil;
}

FancyObject_p method_Block_call_with_arg(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  if(args.size() != 1) {
    errorln("Block#call: didn't get an argument!");
  } else {
    Block_p block = dynamic_cast<Block_p>(self->native_value());
    NativeObject_p first_arg = args.front()->native_value();
    list<FancyObject_p> passed_args;
    if(IS_ARRAY(first_arg)) {
      Array_p args_array = dynamic_cast<Array_p>(first_arg);
      int array_size = args_array->size();
      for(int i = 0; i < array_size; i++) {
        passed_args.push_back(dynamic_cast<FancyObject_p>(args_array->at(i)));
      }
    }
    return block->call(self, passed_args, scope);
  }
  return nil;
}

FancyObject_p method_Block_while_true(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  FancyObject_p first_arg = args.front();
  if(IS_BLOCK(first_arg->native_value())) {
    Block_p while_block = dynamic_cast<Block_p>(self->native_value());
    Block_p then_block = dynamic_cast<Block_p>(first_arg->native_value());
    list<FancyObject_p> empty;
    while(while_block->call(self, empty, scope) != nil) {
      then_block->call(self, empty, scope);
    }
    return nil;
  } else {
    return nil;
  }
}
