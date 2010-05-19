#include "includes.h"

namespace fancy {
  namespace bootstrap {

    /**
     * Number instance methods
     */
    METHOD(Number__plus);
    METHOD(Number__minus);
    METHOD(Number__multiply);
    METHOD(Number__divide);
    METHOD(Number__lt);
    METHOD(Number__lt_eq);
    METHOD(Number__gt);
    METHOD(Number__gt_eq);
    METHOD(Number__eq);
    METHOD(Number__times);
    METHOD(Number__modulo);

    void init_number_class()
    {
      NumberClass->def_method("+", new NativeMethod("+", Number__plus));
      NumberClass->def_method("-", new NativeMethod("-", Number__minus));
      NumberClass->def_method("*", new NativeMethod("*", Number__multiply));
      NumberClass->def_method("/", new NativeMethod("/", Number__divide));
      NumberClass->def_method("<", new NativeMethod("<", Number__lt));
      NumberClass->def_method("<=", new NativeMethod("<=", Number__lt_eq));
      NumberClass->def_method(">", new NativeMethod(">", Number__gt));
      NumberClass->def_method(">=", new NativeMethod(">=", Number__gt_eq));
      NumberClass->def_method("==", new NativeMethod("==", Number__eq));
      NumberClass->def_method("times:", new NativeMethod("times:", Number__times));
      NumberClass->def_method("modulo:", new NativeMethod("modulo:", Number__modulo));
      NumberClass->def_method("%", new NativeMethod("%", Number__modulo));
    }

    /**
     * Number instance methods
     */
    METHOD(Number__plus)
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

    METHOD(Number__minus)
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

    METHOD(Number__multiply)
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

    METHOD(Number__divide)
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

    METHOD(Number__lt)
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

    METHOD(Number__lt_eq)
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


    METHOD(Number__gt)
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

    METHOD(Number__gt_eq)
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

    METHOD(Number__eq)
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

    METHOD(Number__times)
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

    METHOD(Number__modulo)
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
