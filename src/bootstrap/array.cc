#include "includes.h"


namespace fancy {
  namespace bootstrap {

    /**
     * Array class methods
     */
    METHOD(Array_class__new);
    METHOD(Array_class__new__with_size);
    METHOD(Array_class__new__with);

    /**
     * Array instance methods
     */
    METHOD(Array__each);
    METHOD(Array__each_with_index);
    METHOD(Array__insert);
    METHOD(Array__clear);
    METHOD(Array__size);
    METHOD(Array__at);
    METHOD(Array__append);
    METHOD(Array__clone);
    METHOD(Array__remove_at);


    void init_array_class()
    {
      ArrayClass->def_class_method("new", new NativeMethod("new", Array_class__new));
      ArrayClass->def_class_method("new:", new NativeMethod("new:", Array_class__new__with_size));
      
      ArrayClass->def_class_method("new:with:",
                                   new NativeMethod("new:with:",
                                                    "Create a new Array with a given size and default-value.",
                                                    Array_class__new__with));

      ArrayClass->def_method("each:",
                             new NativeMethod("each:",
                                              "Iterate over all elements in Array. Calls a given Block with each element.",
                                              Array__each));

      ArrayClass->def_method("each_with_index:",
                             new NativeMethod("each_with_index:",
                                              "Iterate over all elements in Array. Calls a given Block with each element and its index.",
                                              Array__each_with_index));

      ArrayClass->def_method("<<",
                             new NativeMethod("<<",
                                              "Insert a value into Array.",
                                              Array__insert));

      ArrayClass->def_method("clear",
                             new NativeMethod("clear",
                                              "Clear the Array. Deletes all elements in Array.",
                                              Array__clear));

      ArrayClass->def_method("size",
                             new NativeMethod("size",
                                              "Returns the size of the Array.",
                                              Array__size));

      ArrayClass->def_method("at:",
                             new NativeMethod("at:",
                                              "Returns the value at a given index or nil, if index not valid.",
                                              Array__at));

      ArrayClass->def_method("append:",
                             new NativeMethod("append:",
                                              "Appends another Array onto this one.",
                                              Array__append));

      ArrayClass->def_method("clone",
                             new NativeMethod("clone",
                                              "Clones (shallow copy) the Array.",
                                              Array__clone));

      ArrayClass->def_method("remove_at:",
                             new NativeMethod("remove_at:",
                                              "Removes an element at a given index.",
                                              Array__remove_at));
    }

    /**
     * Array class methods
     */
    METHOD(Array_class__new)
    {
      return new Array();
    }

    METHOD(Array_class__new__with_size)
    {
      EXPECT_ARGS("Array##new:", 1);
      if(Number_p num = dynamic_cast<Number_p>(args[0])) {
        return new Array(num->intval());
      } else {
        return new Array();
      }
    }

    METHOD(Array_class__new__with)
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

    METHOD(Array__each)
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

    METHOD(Array__each_with_index)
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

    METHOD(Array__insert)
    {
      EXPECT_ARGS("Array#insert:", 1);
      Array_p array = dynamic_cast<Array_p>(self);
      array->insert(args[0]);
      return self;
    }

    METHOD(Array__clear)
    {
      Array_p array = dynamic_cast<Array_p>(self);
      array->clear();
      return self;
    }

    METHOD(Array__size)
    {
      Array_p array = dynamic_cast<Array_p>(self);
      return Number::from_int(array->size());
    }

    METHOD(Array__at)
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

    METHOD(Array__append)
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

    METHOD(Array__clone)
    {
      Array_p array = dynamic_cast<Array_p>(self);
      return array->clone();
    }

    METHOD(Array__remove_at)
    {
      EXPECT_ARGS("Array#remove_at:", 1);      
      Array_p array = dynamic_cast<Array_p>(self);
      if(Number_p index = dynamic_cast<Number_p>(args[0])) {
        return array->remove_at(index->intval());
      } else if(Array_p index_arr = dynamic_cast<Array_p>(args[0])) {
        // handle array of index values for removing at several indexes
        vector<FancyObject_p> removed_values;
        int count = 0;
        for(unsigned int i = 0; i < index_arr->size(); i++) {
          if(Number_p idx = dynamic_cast<Number_p>(index_arr->at(i))) {
            removed_values.push_back(array->remove_at(idx->intval() - count));
            count++;
          } else {
            errorln("Array#remove_at: expects Array of Numbers.");
            return nil;
          }
        }
        return new Array(removed_values);
      } else {
        errorln("Array#remove_at: expects Number argument.");
        return nil;
      }
    }

  }
}
