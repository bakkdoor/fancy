#include "includes.h"

#include "../array.h"
#include "../number.h"
#include "../block.h"

namespace fancy {
  namespace bootstrap {

    void init_array_class()
    {

      /**
       * Array class methods
       */
      DEF_CLASSMETHOD(ArrayClass,
                      "new",
                      "Array constructor method.",
                      new);

      DEF_CLASSMETHOD(ArrayClass,
                      "new:",
                      "Array constructor method that takes the initial size of the Array.",
                      new__with_size);

      DEF_CLASSMETHOD(ArrayClass,
                      "new:with:",
                      "Create a new Array with a given size and default-value.",
                      new__with);
      
      /**
       * Array instance methods
       */
      DEF_METHOD(ArrayClass,
                 "each:",
                 "Iterate over all elements in Array. Calls a given Block with each element.",
                 each);

      DEF_METHOD(ArrayClass,
                 "<<",
                 "Insert a value into Array.",
                 insert);

      DEF_METHOD(ArrayClass,
                 "clear",
                 "Clear the Array. Deletes all elements in Array.",
                 clear);

      DEF_METHOD(ArrayClass,
                 "size",
                 "Returns the size of the Array.",
                 size);

      DEF_METHOD(ArrayClass,
                 "at:",
                 "Returns the value at a given index or nil, if index not valid.",
                 at);

      DEF_METHOD(ArrayClass,
                 "at:put:",
                 "Sets the value for a given index.",
                 at__put);

      DEF_METHOD(ArrayClass,
                 "append:",
                 "Appends another Array onto this one.",
                 append);

      DEF_METHOD(ArrayClass,
                 "clone",
                 "Clones (shallow copy) the Array.",
                 clone);

      DEF_METHOD(ArrayClass,
                 "remove_at:",
                 "Removes an element at a given index. \
If given an Array of indices, removes all the elements with these indices.",
                 remove_at);

      DEF_METHOD(ArrayClass,
                 "first",
                 "Returns the first element in the Array",
                 first);

      DEF_METHOD(ArrayClass,
                 "second",
                 "Returns the second element in the Array",
                 second);

      DEF_METHOD(ArrayClass,
                 "third",
                 "Returns the third element in the Array",
                 third);

      DEF_METHOD(ArrayClass,
                 "fourth",
                 "Returns the fourth element in the Array",
                 fourth);

      DEF_METHOD(ArrayClass,
                 "indices:",
                 "Returns an Array of all indices of this item.",
                 indices_);

      DEF_METHOD(ArrayClass,
                 "indices",
                 "Returns an Array of all indices in the Array.",
                 indices);
    }

    /**
     * Array class methods
     */
    CLASSMETHOD(ArrayClass, new)
    {
      return new Array();
    }

    CLASSMETHOD(ArrayClass, new__with_size)
    {
      EXPECT_ARGS("Array##new:", 1);
      if(Number* num = dynamic_cast<Number*>(args[0])) {
        return new Array(num->intval());
      } else {
        return new Array();
      }
    }

    CLASSMETHOD(ArrayClass, new__with)
    {
      EXPECT_ARGS("Array##new:with:", 2);
      FancyObject* arg1 = args[0];
      FancyObject* arg2 = args[1];

      if(Number* num = dynamic_cast<Number*>(arg1)) {
        return new Array(num->intval(), arg2);
      } else {
        return new Array();
      }
    }

    /**
     * Array instance methods
     */

    METHOD(ArrayClass, each)
    {
      EXPECT_ARGS("Array#each:", 1);
      if(IS_BLOCK(args[0])) {
        Array* array = dynamic_cast<Array*>(self);
        Block* block = dynamic_cast<Block*>(args[0]);
        FancyObject* retval = nil;
        array->eval(scope);
        int size = array->size();
        // TODO: fix this to start from and increment ...
        for(int i = 0; i < size; i++) {
          FancyObject* arr[1] = { array->at(i) };
          retval = block->call(self, arr, 1, scope);
        }
        return retval;
      } else { 
        errorln("Array#each: expects Block argument");
        return nil;
      }
    }

    METHOD(ArrayClass, insert)
    {
      EXPECT_ARGS("Array#insert:", 1);
      Array* array = dynamic_cast<Array*>(self);
      array->insert(args[0]);
      return self;
    }

    METHOD(ArrayClass, clear)
    {
      Array* array = dynamic_cast<Array*>(self);
      array->clear();
      return self;
    }

    METHOD(ArrayClass, size)
    {
      Array* array = dynamic_cast<Array*>(self);
      return Number::from_int(array->size());
    }

    METHOD(ArrayClass, at)
    {
      EXPECT_ARGS("Array#at:", 1);
      Array* array = dynamic_cast<Array*>(self);
      if(IS_NUM(args[0])) {
        Number* index = dynamic_cast<Number*>(args[0]);
        assert(index);
        return array->at(index->intval());
      } else {
        errorln("Array#at: expects Integer value.");
        return nil;
      }
    }

    METHOD(ArrayClass, at__put)
    {
      EXPECT_ARGS("Array#at:put:", 2);
      Array* array = dynamic_cast<Array*>(self);
      if(Number* index = dynamic_cast<Number*>(args[0])) {
        array->set_value(index->intval(), args[1]);
        return args[1];
      } else {
        errorln("Array#at:put: expects index (Number) and value.");
        return nil;
      }
    }

    METHOD(ArrayClass, append)
    {
      EXPECT_ARGS("Array#append:", 1);
      Array* array = dynamic_cast<Array*>(self);
      Array* other_array = dynamic_cast<Array*>(args[0]);
      if(other_array) {
        return array->append(other_array);
      } else {
        errorln("Array#append: expects Array argument.");
        return nil;
      }
    }

    METHOD(ArrayClass, clone)
    {
      Array* array = dynamic_cast<Array*>(self);
      return array->clone();
    }

    METHOD(ArrayClass, remove_at)
    {
      EXPECT_ARGS("Array#remove_at:", 1);      
      Array* array = dynamic_cast<Array*>(self);
      if(Number* index = dynamic_cast<Number*>(args[0])) {
        return array->remove_at(index->intval());
      } else if(Array* index_arr = dynamic_cast<Array*>(args[0])) {
        // handle array of index values for removing at several indexes
        vector<FancyObject*> removed_values;
        int count = 0;
        for(unsigned int i = 0; i < index_arr->size(); i++) {
          if(Number* idx = dynamic_cast<Number*>(index_arr->at(i))) {
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

    METHOD(ArrayClass, first)
    {
      Array* array = dynamic_cast<Array*>(self);
      return array->at(0);
    }

    METHOD(ArrayClass, second)
    {
      Array* array = dynamic_cast<Array*>(self);
      return array->at(1);
    }

    METHOD(ArrayClass, third)
    {
      Array* array = dynamic_cast<Array*>(self);
      return array->at(2);
    }

    METHOD(ArrayClass, fourth)
    {
      Array* array = dynamic_cast<Array*>(self);
      return array->at(3);
    }

    METHOD(ArrayClass, indices_)
    {
      EXPECT_ARGS("Array#indices:", 1);
      Array* array = dynamic_cast<Array*>(self);
      vector<FancyObject*> indices;
      FancyObject* eq_args[1] = { args[0] };
      for(unsigned int i = 0; i < array->size(); i++) {
        FancyObject* item = array->at(i);
        if(item->call_method("==", eq_args, 1, scope) != nil) {
          indices.push_back(Number::from_int(i));
        }
      }
      return new Array(indices);
    }

    METHOD(ArrayClass, indices)
    {
      Array* array = dynamic_cast<Array*>(self);
      vector<FancyObject*> indices(array->size(), nil);
      for(unsigned int i = 0; i < array->size(); i++) {
        indices[i] = Number::from_int(i);
      }
      return new Array(indices);
    }

  }
}
