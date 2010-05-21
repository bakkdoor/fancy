#include "includes.h"

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
    }

    /**
     * Number instance methods
     */
    METHOD(NumberClass, plus)
    {
      EXPECT_ARGS("Number#+", 1);
      FancyObject_p arg = args[0];
      if(IS_NUM(arg)) {
        Number_p num1 = dynamic_cast<Number_p>(self);
        Number_p num2 = dynamic_cast<Number_p>(arg);
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
      FancyObject_p arg = args[0];
      if(IS_NUM(arg)) {
        Number_p num1 = dynamic_cast<Number_p>(self);
        Number_p num2 = dynamic_cast<Number_p>(arg);
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
      FancyObject_p arg = args[0];
      if(IS_NUM(arg)) {
        Number_p num1 = dynamic_cast<Number_p>(self);
        Number_p num2 = dynamic_cast<Number_p>(arg);
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
      FancyObject_p arg = args[0];
      if(IS_NUM(arg)) {
        Number_p num1 = dynamic_cast<Number_p>(self);
        Number_p num2 = dynamic_cast<Number_p>(arg);
        // always return double number for division
        return Number::from_double(num1->doubleval() / num2->doubleval());
      } else {
        return Number::from_int(0);
      }
      return self;
    }

    METHOD(NumberClass, lt)
    {
      EXPECT_ARGS("Number#<", 1);
      FancyObject_p arg = args[0];
      if(IS_NUM(arg)) {
        Number_p num1 = dynamic_cast<Number_p>(self);
        Number_p num2 = dynamic_cast<Number_p>(arg);
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
      FancyObject_p arg = args[0];
      if(IS_NUM(arg)) {
        Number_p num1 = dynamic_cast<Number_p>(self);
        Number_p num2 = dynamic_cast<Number_p>(arg);
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
      FancyObject_p arg = args[0];
      if(IS_NUM(arg)) {
        Number_p num1 = dynamic_cast<Number_p>(self);
        Number_p num2 = dynamic_cast<Number_p>(arg);
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
      FancyObject_p arg = args[0];
      if(IS_NUM(arg)) {
        Number_p num1 = dynamic_cast<Number_p>(self);
        Number_p num2 = dynamic_cast<Number_p>(arg);
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
      FancyObject_p arg = args[0];
      if(IS_NUM(arg)) {
        Number_p num1 = dynamic_cast<Number_p>(self);
        Number_p num2 = dynamic_cast<Number_p>(arg);
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
      FancyObject_p arg = args[0];
      if(IS_BLOCK(arg)) {
        Number_p num1 = dynamic_cast<Number_p>(self);
        Block_p block = dynamic_cast<Block_p>(arg);

        // if block is empty (nothing in the blocks body) simply
        // return nil and don't bother wasting any precious time here...
        if(block->is_empty())
          return nil;

        int val = num1->intval();
        if(block->argcount() > 0) {
          FancyObject_p arg[1];
          for(int i = 0; i < val; i++) {
            arg[0] = Number::from_int(i);
            block->call(self, arg, 1, scope);
          }
        } else {
          for(int i = 0; i < val; i++) {
            block->call(self, scope);
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
      Number_p num1 = dynamic_cast<Number_p>(self);
      Number_p num2 = dynamic_cast<Number_p>(args[0]);
      if(num1 && num2) {
        return Number::from_int(num1->intval() % num2->intval());
      } else {
        errorln("Number#modulo: expects Number argument.");
      }
      return self;
    }

  }
}
