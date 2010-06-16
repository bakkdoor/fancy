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
                 "each_with_index:",
                 "Iterate over all elements in Array. Calls a given Block with each element and its index.",
                 each_with_index);

      DEF_METHOD(ArrayClass,
                 "==",
                 "Compares two Arrays where order matters.\
e.g. [1,2,3] == [2,1,3] should not be true",
                 eq);

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
                 "[]",
                 "Given an Array of 2 Numbers, it returns the sub-array between the given indices.\
If given a Number, returns the element at that index.",
                 square_brackets);

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

      DEF_METHOD(ArrayClass,
                 "from:to:",
                 "Returns sub-array starting at from: and going to to:",
                 from__to);

      DEF_METHOD(ArrayClass,
                 "last",
                 "Returns the last element in the Array.",
                 last);

      DEF_METHOD(ArrayClass,
                 "last:",
                 "Returns new Array with last n elements specified.",
                 last_n);

      DEF_METHOD(ArrayClass,
                 "any?:",
                 "Takes condition-block and returns true if any element meets it.",
                 any);

      DEF_METHOD(ArrayClass,
                 "all?:",
                 "Takes condition-block and returns true if all elements meet it.",
                 all);

      DEF_METHOD(ArrayClass,
                 "select:",
                 "Returns a new Array with all elements that meet the given condition block.",
                 select);

      DEF_METHOD(ArrayClass,
                 "select_with_index:",
                 "Same as select, just gets also called with an additional argument for each element's index value.",
                 select_with_index);

      DEF_METHOD(ArrayClass,
                 "reject!:",
                 "Removes all elements in place, that meet the condition.",
                 reject_in_place);
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
        int size = array->size();
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

    METHOD(ArrayClass, each_with_index)
    {
      EXPECT_ARGS("Array#each_with_index:", 1);
      Array* array = dynamic_cast<Array*>(self);
      unsigned int size = array->size();
      FancyObject* retval = nil;
      if(Block* block = dynamic_cast<Block*>(args[0])) {
        for(unsigned int i = 0; i < size; i++) {
          FancyObject* arr[2] = { array->at(i), Number::from_int(i) };
          retval = block->call(self, arr, 2, scope);
        }
        return retval;
      } else {
        for(unsigned int i = 0; i < size; i++) {
          Array* call_args_arr = new Array();
          call_args_arr->insert(array->at(i));
          call_args_arr->insert(Number::from_int(i));
          FancyObject* args[1] = { call_args_arr };
          retval = args[0]->send_message("call:", args, 1, scope, self);
        }
        return retval;
      }
    }

    METHOD(ArrayClass, eq)
    {
      EXPECT_ARGS("Array#==", 1);
      Array* array = dynamic_cast<Array*>(self);
      if(Array* other = dynamic_cast<Array*>(args[0])) {
        if(array->size() == other->size()) {
          for(unsigned int i = 0; i < array->size(); i++) {
            FancyObject* cmp_arg[1] = { other->at(i) };
            if(array->at(i)->send_message("==", cmp_arg, 1, scope, self) == nil) {
              return nil;
            }
          }
          return t;
        }
      }
      return nil;
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

    METHOD(ArrayClass, square_brackets)
    {
      EXPECT_ARGS("Array#[]:", 1);
      if(IS_NUM(args[0])) {
        return FORWARD_METHOD(ArrayClass, at);
      } else if(IS_ARRAY(args[0])) {
        if(Array* indices_array = dynamic_cast<Array*>(args[0])) {
          Number* idx1 = dynamic_cast<Number*>(indices_array->at(0));
          Number* idx2 = dynamic_cast<Number*>(indices_array->at(1));
          if(idx1 && idx2) {
            FancyObject* call_args[2] = { idx1, idx2 };
            return self->send_message("from:to:", call_args, 2, scope, self);
          }
        }
      }
      errorln("Array#[]: expects Integer or Array of Numbers as value.");
      return nil;
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
        if(item->send_message("==", eq_args, 1, scope, self) != nil) {
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

    METHOD(ArrayClass, from__to)
    {
      EXPECT_ARGS("Array#from:to:", 2);
      Number* idx1 = dynamic_cast<Number*>(args[0]);
      Number* idx2 = dynamic_cast<Number*>(args[1]);
      if(idx1 && idx2) {
        Array* array = dynamic_cast<Array*>(self);
        vector<FancyObject*> subarr;
        int i1 = idx1->intval();
        int i2 = idx2->intval();
        // handle negative indices
        if(i1 < 0) {
          i1 = array->size() + i1;
        }
        if(i2 < 0) {
          i2 = array->size() + i2;
        }
        for(int i = i1; i <= i2; i++) {
          subarr.push_back(array->at(i));
        }
        return new Array(subarr);
      }
      errorln("Array#from:to: expects Number values.");
      return new Array();
    }

    METHOD(ArrayClass, last)
    {
      Array* array = dynamic_cast<Array*>(self);
      return array->last();
    }

    METHOD(ArrayClass, last_n)
    {
      EXPECT_ARGS("Array#last:", 1);
      Array* array = dynamic_cast<Array*>(self);
      if(Number* num = dynamic_cast<Number*>(args[0])) {
        return array->last(num->intval());
      } else {
        errorln("Array#last: expects Number value.");
        return nil;
      }
    }

    METHOD(ArrayClass, any)
    {
      EXPECT_ARGS("Array#any?:", 1);
      Array* array = dynamic_cast<Array*>(self);
      for(unsigned int i = 0; i < array->size(); i++) {
        FancyObject* block_arg[1] = { array->at(i) };
        if(args[0]->send_message("call:", block_arg, 1, scope, self) != nil) {
          return t;
        }
      }
      return nil;
    }

    METHOD(ArrayClass, all)
    {
      EXPECT_ARGS("Array#all?:", 1);
      Array* array = dynamic_cast<Array*>(self);
      for(unsigned int i = 0; i < array->size(); i++) {
        FancyObject* block_arg[1] = { array->at(i) };
        if(args[0]->send_message("call:", block_arg, 1, scope, self) == nil) {
          return nil;
        }
      }
      return t;
    }

    METHOD(ArrayClass, select)
    {
      EXPECT_ARGS("Array#select:", 1);
      Array* array = dynamic_cast<Array*>(self);
      Array* ret_array = new Array();
      if(Block* block = dynamic_cast<Block*>(args[0])) {
        for(unsigned int i = 0; i < array->size(); i++) {
          FancyObject* obj = array->at(i);
          FancyObject* block_arg[1] = { obj };
          if(block->call(self, block_arg, 1, scope) != nil) {
            ret_array->insert(obj);
          }
        }
      } else {
        for(unsigned int i = 0; i < array->size(); i++) {
          FancyObject* obj = array->at(i);
          FancyObject* block_arg[1] = { obj };
          if(args[0]->send_message("call:", block_arg, 1, scope, self) != nil) {
            ret_array->insert(obj);
          }
        }
      }
      return ret_array;
    }

    METHOD(ArrayClass, select_with_index)
    {
      EXPECT_ARGS("Array#select_with_index:", 1);
      Array* array = dynamic_cast<Array*>(self);
      Array* ret_array = new Array();
      if(Block* block = dynamic_cast<Block*>(args[0])) {
        for(unsigned int i = 0; i < array->size(); i++) {
          FancyObject* obj = array->at(i);
          Number* idx = Number::from_int(i);
          Array* arr = new Array();
          arr->insert(obj);
          arr->insert(idx);
          FancyObject* block_arg[2] = { obj, idx };
          if(block->call(self, block_arg, 2, scope) != nil) {
            ret_array->insert(arr);
          }
        }
      } else {
        for(unsigned int i = 0; i < array->size(); i++) {
          FancyObject* obj = array->at(i);
          Number* idx = Number::from_int(i);
          Array* arr = new Array();
          arr->insert(obj);
          arr->insert(idx);
          FancyObject* block_arg[1] = { arr };
          if(args[0]->send_message("call:", block_arg, 1, scope, self) != nil) {
            ret_array->insert(arr);
          }
        }
      }
      return ret_array;
    }

    METHOD(ArrayClass, reject_in_place)
    {
      EXPECT_ARGS("Array#reject!:", 1);
      Array* array = dynamic_cast<Array*>(self);
      Array* del_idx_array = new Array();
      if(Block* block = dynamic_cast<Block*>(args[0])) {
        for(unsigned int i = 0; i < array->size(); i++) {
          FancyObject* block_arg[1] = { array->at(i) };
          if(block->call(self, block_arg, 1, scope) != nil) {
            del_idx_array->insert(Number::from_int(i));
          }
        }
      } else {
        for(unsigned int i = 0; i < array->size(); i++) {
          FancyObject* block_arg[1] = { array->at(i) };
          if(args[0]->send_message("call:", block_arg, 1, scope, self) != nil) {
            del_idx_array->insert(Number::from_int(i));
          }
        }
      }

      // now delete all the values with the given indexes in del_idx_array
      FancyObject* arg[1] = { del_idx_array };
      self->send_message("remove_at:", arg, 1, scope, self);
      return self;
    }

  }
}
