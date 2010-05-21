#include "includes.h"

namespace fancy {
  namespace bootstrap {

    void init_string_class()
    {
      DEF_CLASSMETHOD(StringClass,
                      "new",
                      "String constructor.",
                      new);

      DEF_METHOD(StringClass,
                 "downcase",
                 "Returns the downcased version of self.",
                 downcase);

      DEF_METHOD(StringClass,
                 "upcase",
                 "Returns the upcased version of self.",
                 upcase);

      DEF_METHOD(StringClass,
                 "from:to:",
                 "Returns a substring of self starting at index from: till to:.",
                 from__to);

      DEF_METHOD(StringClass,
                 "==",
                 "String comparison.",
                 eq);

      DEF_METHOD(StringClass,
                 "+",
                 "String concatenation.",
                 plus);

      DEF_METHOD(StringClass,
                 "each:",
                 "Calls the given Block with each character in self",
                 each);

      DEF_METHOD(StringClass,
                 "at:",
                 "Returns the character at the given index.",
                 at);
    }

    /**
     * String class methods
     */
    CLASSMETHOD(StringClass, new)
    {
      return String::from_value("");
    }

    /**
     * String instance methods
     */

    METHOD(StringClass, downcase)
    {
      string str = dynamic_cast<String_p>(self)->value();
      std::transform(str.begin(), str.end(), str.begin(), ::tolower);
      return String::from_value(str);
    }

    METHOD(StringClass, upcase)
    {
      string str = dynamic_cast<String_p>(self)->value();
      std::transform(str.begin(), str.end(), str.begin(), ::toupper);
      return String::from_value(str);
    }

    METHOD(StringClass, from__to)
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

    METHOD(StringClass, eq)
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

    METHOD(StringClass, plus)
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

    METHOD(StringClass, each)
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

    METHOD(StringClass, at)
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
