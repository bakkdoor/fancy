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

FancyObject_p method_Block_while_true(FancyObject_p self, list<Expression_p> args, Scope *scope)
{
  FancyObject_p first_arg = args.front()->eval(scope);
  if(IS_BLOCK(self->native_value()) && IS_BLOCK(first_arg->native_value())) {
    Block_p while_block = dynamic_cast<Block_p>(self->native_value());
    Block_p then_block = dynamic_cast<Block_p>(first_arg->native_value());
    list<Expression_p> empty;
    while(while_block->call(self, empty, scope) != nil) {
      then_block->call(self, empty, scope);
    }
  } else {
    return nil;
  }
}
