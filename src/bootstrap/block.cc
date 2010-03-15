#include "includes.h"

void init_block_class()
{  
  BlockClass->def_method("call", new NativeMethod("call", method_Block_call));
  BlockClass->def_method("call:", new NativeMethod("call:", method_Block_call_with_arg));
}


/**
 * Block instance methods
 */

FancyObject_p method_Block_call(FancyObject_p self, list<Expression_p> args, Scope *scope)
{
  if(args.size() > 0) {
    errorln("Block#call got more than 0 arguments!");
  } else {
    if(IS_BLOCK(self->native_value())) {
      Block_p block = dynamic_cast<Block_p>(self->native_value());
      return block->call(self, args, scope);
    } else {
      return nil;
    }
  }
  return nil;
}

FancyObject_p method_Block_call_with_arg(FancyObject_p self, list<Expression_p> args, Scope *scope)
{
  if(args.size() != 1) {
    errorln("Block#call: didn't get an argument!");
  } else {
    if(IS_BLOCK(self->native_value())) {
      Block_p block = dynamic_cast<Block_p>(self->native_value());
      return block->call(self, args, scope);
    } else {
      return nil;
    }
  }
  return nil;
}
