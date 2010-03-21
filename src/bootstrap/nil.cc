#include "includes.h"

void init_nil_class()
{  
  NilClass->def_method("nil?", new NativeMethod("nil?", method_NilClass_is_nil));
  NilClass->def_method("false?", new NativeMethod("false?", method_NilClass_is_nil));

  NilClass->def_method("if_true:", new NativeMethod("if_true:", method_NilClass_if_true));
  NilClass->def_method("true?", new NativeMethod("true?", method_NilClass_if_true));

  NilClass->def_method("if_false:", new NativeMethod("if_false:", method_NilClass_if_false));
  NilClass->def_method("if_nil:", new NativeMethod("if_nil:", method_NilClass_if_false));
}


/**
 * NilClass instance methods
 */

FancyObject_p method_NilClass_is_nil(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  return t;
}

FancyObject_p method_NilClass_if_true(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  return nil;
}

FancyObject_p method_NilClass_if_false(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  FancyObject_p arg = args.front();
  if(IS_BLOCK(arg->native_value())) {
    list<FancyObject_p> empty;
    return dynamic_cast<Block_p>(arg->native_value())->call(arg, empty, scope);
  } else {
    warnln("NilClass#if_false: expects block parameter.");
    return nil;
  }
}
