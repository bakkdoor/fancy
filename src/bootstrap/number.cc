#include "includes.h"

namespace fancy {
  namespace bootstrap {

    void init_number_class()
    {
      NumberClass->def_method("+", new NativeMethod("+", method_Number_plus, 1));
      NumberClass->def_method("-", new NativeMethod("-", method_Number_minus, 1));
      NumberClass->def_method("*", new NativeMethod("*", method_Number_multiply, 1));
      NumberClass->def_method("/", new NativeMethod("/", method_Number_divide, 1));
      NumberClass->def_method("<", new NativeMethod("<", method_Number_lt, 1));
      NumberClass->def_method("<=", new NativeMethod("<=", method_Number_lt_eq, 1));
      NumberClass->def_method(">", new NativeMethod(">", method_Number_gt, 1));
      NumberClass->def_method(">=", new NativeMethod(">=", method_Number_gt_eq, 1));
      NumberClass->def_method("==", new NativeMethod("==", method_Number_eq, 1));
      NumberClass->def_method("times:", new NativeMethod("times:", method_Number_times, 1));
      NumberClass->def_method("modulo:", new NativeMethod("modulo:", method_Number_modulo, 1));
      NumberClass->def_method("%", new NativeMethod("%", method_Number_modulo, 1));
    }

    /**
     * Number instance methods
     */
    FancyObject_p method_Number_plus(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("Number#+", 1);
      FancyObject_p arg = args.front();
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

    FancyObject_p method_Number_minus(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("Number#-", 1);
      FancyObject_p arg = args.front();
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

    FancyObject_p method_Number_multiply(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("Number#*", 1);
      FancyObject_p arg = args.front();
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

    FancyObject_p method_Number_divide(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("Number#/", 1);
      FancyObject_p arg = args.front();
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

    FancyObject_p method_Number_lt(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("Number#<", 1);
      FancyObject_p arg = args.front();
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

    FancyObject_p method_Number_lt_eq(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("Number#<=", 1);
      FancyObject_p arg = args.front();
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


    FancyObject_p method_Number_gt(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("Number#>", 1);
      FancyObject_p arg = args.front();
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

    FancyObject_p method_Number_gt_eq(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("Number#>=", 1);
      FancyObject_p arg = args.front();
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

    FancyObject_p method_Number_eq(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("Number#==", 1);
      FancyObject_p arg = args.front();
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

    FancyObject_p method_Number_times(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("Number#times:", 1);
      FancyObject_p arg = args.front();
      if(IS_BLOCK(arg)) {
        Number_p num1 = dynamic_cast<Number_p>(self);
        Block_p block = dynamic_cast<Block_p>(arg);

        // if block is empty (nothing in the blocks body) simply
        // return nil and don't bother wasting any precious time here...
        if(block->is_empty())
          return nil;

        int val = num1->intval();
        if(block->argcount() > 0) {
          for(int i = 0; i < val; i++) {
            block->call(self, list<FancyObject_p>(1, Number::from_int(i)), scope);
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

    FancyObject_p method_Number_modulo(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("Number#modulo:", 1);
      Number_p num1 = dynamic_cast<Number_p>(self);
      Number_p num2 = dynamic_cast<Number_p>(args.front());
      if(num1 && num2) {
        return Number::from_int(num1->intval() % num2->intval());
      } else {
        errorln("Number#modulo: expects Number argument.");
      }
      return self;
    }

  }
}
