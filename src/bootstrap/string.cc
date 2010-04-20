#include "includes.h"

namespace fancy {
  namespace bootstrap {

    void init_string_class()
    {
      StringClass->def_class_method("new", new NativeMethod("new", class_method_String_new));

      StringClass->def_method("downcase", new NativeMethod("downcase", method_String_downcase));
      StringClass->def_method("upcase", new NativeMethod("upcase", method_String_upcase));
      StringClass->def_method("from:to:", new NativeMethod("from:to:", method_String_from__to));
      StringClass->def_method("==", new NativeMethod("==", method_String_eq));
      StringClass->def_method("+", new NativeMethod("+", method_String_plus));
    }

    /**
     * String class methods
     */
    FancyObject_p class_method_String_new(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      return String::from_value("");
    }

    /**
     * String instance methods
     */

    FancyObject_p method_String_downcase(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      string str = dynamic_cast<String_p>(self)->value();
      std::transform(str.begin(), str.end(), str.begin(), ::tolower);
      return String::from_value(str);
    }

    FancyObject_p method_String_upcase(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      string str = dynamic_cast<String_p>(self)->value();
      std::transform(str.begin(), str.end(), str.begin(), ::toupper);
      return String::from_value(str);
    }

    FancyObject_p method_String_from__to(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      EXPECT_ARGS("String#from:to:", 2);
      string str = dynamic_cast<String_p>(self)->value();
      FancyObject_p arg1 = args[0];
      FancyObject_p arg2 = args[1];
  
      if(IS_INT(arg1) && IS_INT(arg2)) {
        Number_p idx1 = dynamic_cast<Number_p>(arg1);
        Number_p idx2 = dynamic_cast<Number_p>(arg2);
        string substr = str.substr(idx1->intval(), (idx2->intval() + 1) - idx1->intval());
        return String::from_value(substr);
      } else {
        errorln("String#to:from: expects 2 Integer arguments");
        return self;
      }

      return nil;
    }

    FancyObject_p method_String_eq(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
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

    FancyObject_p method_String_plus(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
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

  }
}
