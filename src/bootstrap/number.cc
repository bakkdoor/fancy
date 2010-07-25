#include "../../vendor/gc/include/gc.h"
#include "../../vendor/gc/include/gc_cpp.h"
#include "../../vendor/gc/include/gc_allocator.h"

#include "includes.h"

#include "../number.h"
#include "../block.h"
#include "../errors.h"
#include "../array.h"


namespace fancy {
  namespace bootstrap {

    void init_number_class()
    {
      DEF_METHOD(NumberClass,
                 "+",
                 "Number addition.",
                 plus);

      DEF_METHOD(NumberClass,
                 "-",
                 "Number subtraction.",
                 minus);

      DEF_METHOD(NumberClass,
                 "*",
                 "Number multiplication.",
                 multiply);

      DEF_METHOD(NumberClass,
                 "/",
                 "Number division.",
                 divide);

      DEF_METHOD(NumberClass,
                 "<",
                 "Indicates, if this Number is smaller than a given.",
                 lt);

      DEF_METHOD(NumberClass,
                 "<=",
                 "Indicates, if this Number is smaller (or equal) than a given.",
                 lt_eq);

      DEF_METHOD(NumberClass,
                 ">",
                 "Indicates, if this Number is larger than a given.",
                 gt);

      DEF_METHOD(NumberClass,
                 ">=",
                 "Indicates, if this Number is larger (or equal) than a given.",
                 gt_eq);

      DEF_METHOD(NumberClass,
                 "==",
                 "Indicates, if this Number is equal to a given.",
                 eq);

      DEF_METHOD(NumberClass,
                 "times:",
                 "Calls a given block self times.",
                 times);

      DEF_METHOD(NumberClass,
                 "modulo:",
                 "Calculates the modulo value of self and a given Number.",
                 modulo);

      DEF_METHOD(NumberClass,
                 "%",
                 "Calculates the modulo value of self and a given Number.",
                 modulo);

      DEF_METHOD(NumberClass,
                 "div:",
                 "Calculates the Integer division value of self and a given Number.",
                 div);

      DEF_METHOD(NumberClass,
                 "upto:",
                 "Returns an Array of Numbers from self up to a given (larger) Number.",
                 upto);

      DEF_METHOD(NumberClass,
                 "downto:",
                 "Returns an Array of Numbers from self down to a given (smaller) Number.",
                 downto);

      DEF_METHOD(NumberClass,
                 "upto:do_each:",
                 "Calls a given block for each value between self and a given (larger) Number.",
                 upto__do_each);

      DEF_METHOD(NumberClass,
                 "downto:do_each:",
                 "Calls a given block for each value between self and a given (smaller) Number.",
                 downto__do_each);

      DEF_METHOD(NumberClass,
                 "**",
                 "Calculates the given power of a Number.",
                 power);

    }

    /**
     * Number instance methods
     */
    METHOD(NumberClass, plus)
    {
      EXPECT_ARGS("Number#+", 1);
      FancyObject* arg = args[0];
      if(IS_NUM(arg)) {
        Number* num1 = dynamic_cast<Number*>(self);
        Number* num2 = dynamic_cast<Number*>(arg);
        if(num1->is_double() || num2->is_double()) {
          return Number::from_double(num1->doubleval() + num2->doubleval());
        } else {
          return Number::from_int(num1->intval() + num2->intval());
        }
      } else {
        return Number::from_int(0);
      }
      return self;
    }

    METHOD(NumberClass, minus)
    {
      EXPECT_ARGS("Number#-", 1);
      FancyObject* arg = args[0];
      if(IS_NUM(arg)) {
        Number* num1 = dynamic_cast<Number*>(self);
        Number* num2 = dynamic_cast<Number*>(arg);
        if(num1->is_double() || num2->is_double()) {
          return Number::from_double(num1->doubleval() - num2->doubleval());
        } else {
          return Number::from_int(num1->intval() - num2->intval());
        }
      } else {
        return Number::from_int(0);
      }
      return self;
    }

    METHOD(NumberClass, multiply)
    {
      EXPECT_ARGS("Number#*", 1);
      FancyObject* arg = args[0];
      if(IS_NUM(arg)) {
        Number* num1 = dynamic_cast<Number*>(self);
        Number* num2 = dynamic_cast<Number*>(arg);
        if(num1->is_double() || num2->is_double()) {
          return Number::from_double(num1->doubleval() * num2->doubleval());
        } else {
          return Number::from_int(num1->intval() * num2->intval());
        }
      } else {
        return Number::from_int(0);
      }
      return self;
    }

    METHOD(NumberClass, divide)
    {
      EXPECT_ARGS("Number#/", 1);
      FancyObject* arg = args[0];
      if(IS_NUM(arg)) {
        Number* num1 = dynamic_cast<Number*>(self);
        Number* num2 = dynamic_cast<Number*>(arg);
        if(num2->intval() == 0) {
          throw new DivisionByZeroError();
        } else {
          // always return double number for division
          return Number::from_double(num1->doubleval() / num2->doubleval());
        }
      } else {
        return Number::from_int(0);
      }
      return self;
    }

    METHOD(NumberClass, lt)
    {
      EXPECT_ARGS("Number#<", 1);
      FancyObject* arg = args[0];
      if(IS_NUM(arg)) {
        Number* num1 = dynamic_cast<Number*>(self);
        Number* num2 = dynamic_cast<Number*>(arg);
        if(num1->doubleval() < num2->doubleval()) {
          return t;
        } else {
          return nil;
        }
      } else {
        errorln("Number#< only works on Number objects!");
      }
      return nil;
    }

    METHOD(NumberClass, lt_eq)
    {
      EXPECT_ARGS("Number#<=", 1);
      FancyObject* arg = args[0];
      if(IS_NUM(arg)) {
        Number* num1 = dynamic_cast<Number*>(self);
        Number* num2 = dynamic_cast<Number*>(arg);
        if(num1->doubleval() <= num2->doubleval()) {
          return t;
        } else {
          return nil;
        }
      } else {
        errorln("Number#<= only works on Number objects!");
      }
      return nil;
    }


    METHOD(NumberClass, gt)
    {
      EXPECT_ARGS("Number#>", 1);
      FancyObject* arg = args[0];
      if(IS_NUM(arg)) {
        Number* num1 = dynamic_cast<Number*>(self);
        Number* num2 = dynamic_cast<Number*>(arg);
        if(num1->doubleval() > num2->doubleval()) {
          return t;
        } else {
          return nil;
        }
      } else {
        errorln("Number#> only works on Number objects!");
      }
      return nil;
    }

    METHOD(NumberClass, gt_eq)
    {
      EXPECT_ARGS("Number#>=", 1);
      FancyObject* arg = args[0];
      if(IS_NUM(arg)) {
        Number* num1 = dynamic_cast<Number*>(self);
        Number* num2 = dynamic_cast<Number*>(arg);
        if(num1->doubleval() >= num2->doubleval()) {
          return t;
        } else {
          return nil;
        }
      } else {
        errorln("Number#>= only works on Number objects!");
      }
      return nil;
    }

    METHOD(NumberClass, eq)
    {
      EXPECT_ARGS("Number#==", 1);
      FancyObject* arg = args[0];
      if(IS_NUM(arg)) {
        Number* num1 = dynamic_cast<Number*>(self);
        Number* num2 = dynamic_cast<Number*>(arg);
        if(num1->doubleval() == num2->doubleval()) {
          return t;
        } else {
          return nil;
        }
      }
      return nil;
    }

    METHOD(NumberClass, times)
    {
      EXPECT_ARGS("Number#times:", 1);
      FancyObject* arg = args[0];
      if(IS_BLOCK(arg)) {
        Number* num1 = dynamic_cast<Number*>(self);
        Block* block = dynamic_cast<Block*>(arg);

        // if block is empty (nothing in the blocks body) simply
        // return nil and don't bother wasting any precious time here...
        if(block->is_empty())
          return nil;

        int val = num1->intval();
        if(block->argcount() > 0) {
          FancyObject* arg[1];
          for(int i = 0; i < val; i++) {
            arg[0] = Number::from_int(i);
            block->call(self, arg, 1, scope, sender);
          }
        } else {
          for(int i = 0; i < val; i++) {
            block->call(self, scope, sender);
          }
        }
      } else {
        errorln("Number#times: expects Block object as parameter!");
      }
      return nil;
    }

    METHOD(NumberClass, modulo)
    {
      EXPECT_ARGS("Number#modulo:", 1);
      Number* num1 = dynamic_cast<Number*>(self);
      Number* num2 = dynamic_cast<Number*>(args[0]);
      if(num1 && num2) {
        return Number::from_int(num1->intval() % num2->intval());
      } else {
        errorln("Number#modulo: expects Number argument.");
      }
      return self;
    }

    METHOD(NumberClass, div)
    {
      EXPECT_ARGS("Number#div:", 1);
      Number* num1 = dynamic_cast<Number*>(self);
      Number* num2 = dynamic_cast<Number*>(args[0]);
      if(num1 && num2) {
        return Number::from_int(num1->intval() / num2->intval());
      } else {
        errorln("Number#div: expects Number argument.");
      }
      return self;
    }

    METHOD(NumberClass, upto)
    {
      EXPECT_ARGS("Number#upto:", 1);
      Number* num1 = dynamic_cast<Number*>(self);
      Number* num2 = dynamic_cast<Number*>(args[0]);
      if(num1 && num2) {
        int i = num1->intval();
        int max = num2->intval();
        if(i <= max) {
          int count = 0;
          vector<FancyObject*> arr(max - i + 1, nil);
          for(; i <= max; i++) {
            arr[count++] = Number::from_int(i);
          }
          return new Array(arr);
        } else {
          return new Array();
        }
      }
      errorln("Number#upto: expects Number argument.");
      return nil;
    }

    METHOD(NumberClass, downto)
    {
      EXPECT_ARGS("Number#downto:", 1);
      Number* num1 = dynamic_cast<Number*>(self);
      Number* num2 = dynamic_cast<Number*>(args[0]);
      if(num1 && num2) {
        int i = num1->intval();
        int min = num2->intval();
        if(i >= min) {
          int count = 0;
          vector<FancyObject*> arr(i - min + 1, nil);
          for(; i >= min; i--) {
            arr[count++] = Number::from_int(i);
          }
          return new Array(arr);
        } else {
          return new Array();
        }
      }
      errorln("Number#downto: expects Number argument.");
      return nil;
    }

    METHOD(NumberClass, upto__do_each)
    {
      EXPECT_ARGS("Number#upto:do_each:", 2);
      Number* num1 = dynamic_cast<Number*>(self);
      Number* num2 = dynamic_cast<Number*>(args[0]);
      if(num1 && num2) {
        // special case for Blocks (better performance)
        if(Block* block = dynamic_cast<Block*>(args[1])) {
          for(int i = num1->intval(); i <= num2->intval(); i++) {
            FancyObject* block_arg[1] = { Number::from_int(i) };
            block->call(self, block_arg, 1, scope, sender);
          }
        } else {
          for(int i = num1->intval(); i <= num2->intval(); i++) {
            FancyObject* block_arg[1] = { Number::from_int(i) };
            args[1]->send_message("call:", block_arg, 1, scope, self);
          }
        }
        return nil;
      }
      errorln("Number#upto:do_each expects Number and callable argument.");
      return nil;
    }


    METHOD(NumberClass, downto__do_each)
    {
      EXPECT_ARGS("Number#downto:do_each:", 2);
      Number* num1 = dynamic_cast<Number*>(self);
      Number* num2 = dynamic_cast<Number*>(args[0]);
      if(num1 && num2) {
        // special case for Blocks (better performance)
        if(Block* block = dynamic_cast<Block*>(args[1])) {
          for(int i = num1->intval(); i >= num2->intval(); i--) {
            FancyObject* block_arg[1] = { Number::from_int(i) };
            block->call(self, block_arg, 1, scope, sender);
          }
        } else {
          for(int i = num1->intval(); i >= num2->intval(); i--) {
            FancyObject* block_arg[1] = { Number::from_int(i) };
            args[1]->send_message("call:", block_arg, 1, scope, self);
          }
        }
        return nil;
      }
      errorln("Number#downto:do_each expects Number and callable argument.");
      return nil;
    }

    METHOD(NumberClass, power)
    {
      EXPECT_ARGS("Number#**", 1);
      Number* num1 = dynamic_cast<Number*>(self);
      Number* num2 = dynamic_cast<Number*>(args[0]);
      if(num1 && num2) {
        return Number::from_double(pow(NUMVAL(num1), NUMVAL(num2)));
      }
      errorln("Number#** expects Number argument.");
      return self;
    }

  }
}
