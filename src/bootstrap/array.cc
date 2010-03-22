#include "includes.h"

void init_array_class()
{  
  ArrayClass->def_method("each:", new NativeMethod("each:", method_Array_each));
}


/**
 * Array instance methods
 */

FancyObject_p method_Array_each(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  if(IS_BLOCK(args.front()->native_value())) {
    Array_p array = dynamic_cast<Array_p>(self->native_value());
    Block_p block = dynamic_cast<Block_p>(args.front()->native_value());
    FancyObject_p retval = nil;
    array->eval(scope);
    int size = array->size();
    // TODO: fix this to start from and increment ...
    for(int i = size-1; i >= 0; i--) {
      retval = block->call(self, list<FancyObject_p>(1, array->at(i)), scope);
    }
    return retval;
  } else { 
    errorln("Array#each: expects Block argument");
    return nil;
  }
}
