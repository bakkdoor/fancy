#include "includes.h"

namespace fancy {
  namespace bootstrap {

    /**
     * String class methods
     */
    METHOD(String_class__new);

    /**
     * String instance methods
     */
    METHOD(String__downcase);
    METHOD(String__upcase);
    METHOD(String__from__to);
    METHOD(String__eq);
    METHOD(String__plus);
    METHOD(String__each);
    METHOD(String__at);

    void init_string_class()
    {
      StringClass->def_class_method("new", new NativeMethod("new", String_class__new));

      StringClass->def_method("downcase", new NativeMethod("downcase", String__downcase));
      StringClass->def_method("upcase", new NativeMethod("upcase", String__upcase));
      StringClass->def_method("from:to:", new NativeMethod("from:to:", String__from__to));
      StringClass->def_method("==", new NativeMethod("==", String__eq));
      StringClass->def_method("+", new NativeMethod("+", String__plus));
      StringClass->def_method("each:", new NativeMethod("each:", String__each));
      StringClass->def_method("at:", new NativeMethod("at:", String__at));
    }

    /**
     * String class methods
     */
    METHOD(String_class__new)
    {
      return String::from_value("");
    }

    /**
     * String instance methods
     */

    METHOD(String__downcase)
    {
      string str = dynamic_cast<String_p>(self)->value();
      std::transform(str.begin(), str.end(), str.begin(), ::tolower);
      return String::from_value(str);
    }

    METHOD(String__upcase)
    {
      string str = dynamic_cast<String_p>(self)->value();
      std::transform(str.begin(), str.end(), str.begin(), ::toupper);
      return String::from_value(str);
    }

    METHOD(String__from__to)
    {
      EXPECT_ARGS("String#from:to:", 2);
      string str = dynamic_cast<String_p>(self)->value();
      FancyObject_p arg1 = args[0];
      FancyObject_p arg2 = args[1];
  
      if(IS_INT(arg1) && IS_INT(arg2)) {
        Number_p idx1 = dynamic_cast<Number_p>(arg1);
        Number_p idx2 = dynamic_cast<Number_p>(arg2);
        string substr;
        // deal with negative indexes
        if(idx2->intval() < 0) {
          substr = str.substr(idx1->intval(), (str.length() + 1) + idx2->intval());
        } else {
          substr = str.substr(idx1->intval(), (idx2->intval() + 1) - idx1->intval());
        }
        return String::from_value(substr);
      } else {
        errorln("String#to:from: expects 2 Integer arguments");
        return self;
      }

      return nil;
    }

    METHOD(String__eq)
    {
      EXPECT_ARGS("String#eq:", 1);
      FancyObject_p arg = args[0];
      if(IS_STRING(arg)) {
        string str1 = dynamic_cast<String_p>(self)->value();
        string str2 = dynamic_cast<String_p>(arg)->value();
        if(str1 == str2) {
          return t;
        }
      }
      return nil;
    }

    METHOD(String__plus)
    {
      EXPECT_ARGS("String#+", 1);
      if(String_p arg = dynamic_cast<String_p>(args[0])) {
        string str1 = dynamic_cast<String_p>(self)->value();
        string str2 = arg->value();
        return String::from_value(str1 + str2);
      }
      errorln("String#+ expects String argument.");
      return nil;
    }

    METHOD(String__each)
    {
      EXPECT_ARGS("String#each:", 1);
      if(Block_p block = dynamic_cast<Block_p>(args[0])) {
        string str = self->to_s();
        FancyObject_p retval = nil;
        for(string::iterator it = str.begin(); it != str.end(); it++) {
          string str(&(*it), 1);
          FancyObject_p block_args[1] = { String::from_value(str) };
          retval = block->call(self, block_args, 1, scope);
        }
        return retval;
      }
      errorln("String#each: expects Block argument.");
      return nil;
    }

    METHOD(String__at)
    {
      EXPECT_ARGS("String#at:", 1);
      if(Number_p index = dynamic_cast<Number_p>(args[0])) {
        string str = self->to_s();
        string char_str = string(&str.at(index->intval()), 1);
        return String::from_value(char_str);
      }
      errorln("String#at: expects Number argument.");
      return nil;
    }

  }
}
