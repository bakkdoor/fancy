#include "includes.h"


namespace fancy {
  namespace bootstrap {

    void init_array_class()
    {
      ArrayClass->def_class_method("new", new NativeMethod("new", class_method_Array_new));
      ArrayClass->def_class_method("new:", new NativeMethod("new:", class_method_Array_new__with_size, 1));
      ArrayClass->def_class_method("new:with:", new NativeMethod("new:with:", class_method_Array_new__with, 2));
      ArrayClass->def_method("each:", new NativeMethod("each:", method_Array_each));
      ArrayClass->def_method("each_with_index:", new NativeMethod("each_with_index:", method_Array_each_with_index, 1));
      ArrayClass->def_method("<<", new NativeMethod("<<", method_Array_insert, 1));
      ArrayClass->def_method("clear", new NativeMethod("clear", method_Array_clear));
      ArrayClass->def_method("size", new NativeMethod("size", method_Array_size));
      ArrayClass->def_method("at:", new NativeMethod("at:", method_Array_at, 1));
      ArrayClass->def_method("append:", new NativeMethod("append:", method_Array_append, 1));
      ArrayClass->def_method("clone", new NativeMethod("clone", method_Array_clone));
    }

    /**
     * Array class methods
     */
    FancyObject_p class_method_Array_new(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      return new Array();
    }

    FancyObject_p class_method_Array_new__with_size(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      EXPECT_ARGS("Array##new:", 1);
      if(Number_p num = dynamic_cast<Number_p>(args[0])) {
        return new Array(num->intval());
      } else {
        return new Array();
      }
    }

    FancyObject_p class_method_Array_new__with(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      EXPECT_ARGS("Array##new:with:", 2);
      FancyObject_p arg1 = args[0];
      FancyObject_p arg2 = args[1];

      if(Number_p num = dynamic_cast<Number_p>(arg1)) {
        return new Array(num->intval(), arg2);
      } else {
        return new Array();
      }
    }

    /**
     * Array instance methods
     */

    FancyObject_p method_Array_each(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      EXPECT_ARGS("Array#each:", 1);
      if(IS_BLOCK(args[0])) {
        Array_p array = dynamic_cast<Array_p>(self);
        Block_p block = dynamic_cast<Block_p>(args[0]);
        FancyObject_p retval = nil;
        array->eval(scope);
        int size = array->size();
        // TODO: fix this to start from and increment ...
        for(int i = 0; i < size; i++) {
          FancyObject_p arr[1] = { array->at(i) };
          retval = block->call(self, arr, 1, scope);
        }
        return retval;
      } else { 
        errorln("Array#each: expects Block argument");
        return nil;
      }
    }

    FancyObject_p method_Array_each_with_index(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      EXPECT_ARGS("Array#each_with_index:", 1);
      if(IS_BLOCK(args[0])) {
        Array_p array = dynamic_cast<Array_p>(self);
        Block_p block = dynamic_cast<Block_p>(args[0]);
        FancyObject_p retval = nil;
        array->eval(scope);
        int size = array->size();
        // TODO: fix this to start from and increment ...
        for(int i = 0; i < size; i++) {
          FancyObject_p block_args[2] = { array->at(i), Number::from_int(i) };
          retval = block->call(self, block_args, 2, scope);
        }
        return retval;
      } else { 
        errorln("Array#each_with_index: expects Block argument");
        return nil;
      }
    }

    FancyObject_p method_Array_insert(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      EXPECT_ARGS("Array#insert:", 1);
      Array_p array = dynamic_cast<Array_p>(self);
      array->insert(args[0]);
      return self;
    }

    FancyObject_p method_Array_clear(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      Array_p array = dynamic_cast<Array_p>(self);
      array->clear();
      return self;
    }

    FancyObject_p method_Array_size(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      Array_p array = dynamic_cast<Array_p>(self);
      return Number::from_int(array->size());
    }

    FancyObject_p method_Array_at(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      EXPECT_ARGS("Array#at:", 1);
      Array_p array = dynamic_cast<Array_p>(self);
      if(IS_NUM(args[0])) {
        Number_p index = dynamic_cast<Number_p>(args[0]);
        assert(index);
        return array->at(index->intval());
      } else {
        errorln("Array#at: expects Integer value.");
        return nil;
      }
    }

    FancyObject_p method_Array_append(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      EXPECT_ARGS("Array#append:", 1);
      Array_p array = dynamic_cast<Array_p>(self);
      Array_p other_array = dynamic_cast<Array_p>(args[0]);
      if(other_array) {
        return array->append(other_array);
      } else {
        errorln("Array#append: expects Array argument.");
        return nil;
      }
    }

    FancyObject_p method_Array_clone(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      Array_p array = dynamic_cast<Array_p>(self);
      return array->clone();
    }

  }
}
