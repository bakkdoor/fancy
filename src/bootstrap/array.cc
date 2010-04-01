#include "includes.h"

void init_array_class()
{  
  ArrayClass->def_method("each:", new NativeMethod("each:", method_Array_each));
  ArrayClass->def_method("each_with_index:", new NativeMethod("each_with_index:", method_Array_each_with_index));
  ArrayClass->def_method("<<", new NativeMethod("<<", method_Array_insert));
  ArrayClass->def_method("clear", new NativeMethod("clear", method_Array_clear));
  ArrayClass->def_method("size", new NativeMethod("size", method_Array_size));
  ArrayClass->def_method("at:", new NativeMethod("at:", method_Array_at));
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
    for(int i = 0; i < size; i++) {
      retval = block->call(self, list<FancyObject_p>(1, array->at(i)), scope);
    }
    return retval;
  } else { 
    errorln("Array#each: expects Block argument");
    return nil;
  }
}

FancyObject_p method_Array_each_with_index(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  if(IS_BLOCK(args.front()->native_value())) {
    Array_p array = dynamic_cast<Array_p>(self->native_value());
    Block_p block = dynamic_cast<Block_p>(args.front()->native_value());
    FancyObject_p retval = nil;
    array->eval(scope);
    int size = array->size();
    // TODO: fix this to start from and increment ...
    for(int i = 0; i < size; i++) {
      list<FancyObject_p> block_args;
      block_args.push_back(array->at(i));
      block_args.push_back(NumberClass->create_instance(Number::from_int(i)));
      retval = block->call(self, block_args, scope);
    }
    return retval;
  } else { 
    errorln("Array#each_with_index: expects Block argument");
    return nil;
  }
}

FancyObject_p method_Array_insert(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  Array_p array = dynamic_cast<Array_p>(self->native_value());
  array->insert(args.front());
  return self;
}

FancyObject_p method_Array_clear(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  Array_p array = dynamic_cast<Array_p>(self->native_value());
  array->clear();
  return self;
}

FancyObject_p method_Array_size(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  Array_p array = dynamic_cast<Array_p>(self->native_value());
  return NumberClass->create_instance(Number::from_int(array->size()));
}

FancyObject_p method_Array_at(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  Array_p array = dynamic_cast<Array_p>(self->native_value());
  if(IS_NUM(args.front()->native_value())) {
    Number_p index = dynamic_cast<Number_p>(args.front()->native_value());
    assert(index);
    return array->at(index->intval());
  } else {
    errorln("Array#at: expects Integer value.");
    return nil;
  }
}
