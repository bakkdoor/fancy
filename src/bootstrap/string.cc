#include "../../vendor/gc/include/gc.h"
#include "../../vendor/gc/include/gc_cpp.h"
#include "../../vendor/gc/include/gc_allocator.h"

#include "includes.h"

// used for parse_string() in String#eval
#include "../parser/parser.h"

#include "../string.h"
#include "../number.h"
#include "../block.h"
#include "../array.h"

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

      DEF_METHOD(StringClass,
                 "eval",
                 "Interprets the String as Fancy code and tries to run it.",
                 eval);

      DEF_METHOD(StringClass,
                 "split:",
                 "Splits a String at a given seperator String and returns the substrings as an Array.",
                 split);
    }

    /**
     * String class methods
     */
    CLASSMETHOD(StringClass, new)
    {
      return FancyString::from_value("");
    }

    /**
     * String instance methods
     */

    METHOD(StringClass, downcase)
    {
      string str = dynamic_cast<FancyString*>(self)->value();
      std::transform(str.begin(), str.end(), str.begin(), ::tolower);
      return FancyString::from_value(str);
    }

    METHOD(StringClass, upcase)
    {
      string str = dynamic_cast<FancyString*>(self)->value();
      std::transform(str.begin(), str.end(), str.begin(), ::toupper);
      return FancyString::from_value(str);
    }

    METHOD(StringClass, from__to)
    {
      EXPECT_ARGS("String#from:to:", 2);
      string str = dynamic_cast<FancyString*>(self)->value();
      FancyObject* arg1 = args[0];
      FancyObject* arg2 = args[1];

      if(IS_INT(arg1) && IS_INT(arg2)) {
        Number* idx1 = dynamic_cast<Number*>(arg1);
        Number* idx2 = dynamic_cast<Number*>(arg2);
        string substr;
        // deal with negative indexes
        if(idx2->intval() < 0) {
          substr = str.substr(idx1->intval(), (str.length() + 1) + idx2->intval());
        } else {
          substr = str.substr(idx1->intval(), (idx2->intval() + 1) - idx1->intval());
        }
        return FancyString::from_value(substr);
      } else {
        errorln("String#to:from: expects 2 Integer arguments");
        return self;
      }

      return nil;
    }

    METHOD(StringClass, eq)
    {
      EXPECT_ARGS("String#eq:", 1);
      FancyObject* arg = args[0];
      if(IS_STRING(arg)) {
        string str1 = dynamic_cast<FancyString*>(self)->value();
        string str2 = dynamic_cast<FancyString*>(arg)->value();
        if(str1 == str2) {
          return t;
        }
      }
      return nil;
    }

    METHOD(StringClass, plus)
    {
      EXPECT_ARGS("String#+", 1);
      if(FancyString* arg = dynamic_cast<FancyString*>(args[0])) {
        string str1 = dynamic_cast<FancyString*>(self)->value();
        string str2 = arg->value();
        return FancyString::from_value(str1 + str2);
      }
      errorln("String#+ expects String argument.");
      return nil;
    }

    METHOD(StringClass, each)
    {
      EXPECT_ARGS("String#each:", 1);
      if(Block* block = dynamic_cast<Block*>(args[0])) {
        string str = self->to_s();
        FancyObject* retval = nil;
        for(string::iterator it = str.begin(); it != str.end(); it++) {
          string str(&(*it), 1);
          FancyObject* block_args[1] = { FancyString::from_value(str) };
          retval = block->call(self, block_args, 1, scope, sender);
        }
        return retval;
      }
      errorln("String#each: expects Block argument.");
      return nil;
    }

    METHOD(StringClass, at)
    {
      EXPECT_ARGS("String#at:", 1);
      if(Number* index = dynamic_cast<Number*>(args[0])) {
        string str = self->to_s();
        string char_str = string(&str.at(index->intval()), 1);
        return FancyString::from_value(char_str);
      }
      errorln("String#at: expects Number argument.");
      return nil;
    }

    METHOD(StringClass, eval)
    {
      string code = self->to_s();
      return parser::parse_string(code);
    }

    METHOD(StringClass, split)
    {
      EXPECT_ARGS("String#split:" , 1);
      string str = self->to_s();
      string seperator = args[0]->to_s();
      vector<string> parts = string_split(str, seperator, true);
      Array* arr = new Array(parts.size());
      for(unsigned int i = 0; i < parts.size(); i++) {
	arr->set_value(i, FancyString::from_value(parts[i]));
      }
      return arr;
    }

  }
}
