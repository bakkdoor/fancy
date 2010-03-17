#include "includes.h"

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
}

/**
 * Number instance methods
 */
FancyObject_p method_Number_plus(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  FancyObject_p arg = args.front();
  if(IS_NUM(arg->native_value())) {
    Number_p num1 = dynamic_cast<Number_p>(self->native_value());
    Number_p num2 = dynamic_cast<Number_p>(arg->native_value());
    if(num1->is_double() || num2->is_double()) {
      return NumberClass->create_instance(Number::from_double(num1->doubleval() + num2->doubleval()));
    } else {
      return NumberClass->create_instance(Number::from_int(num1->intval() + num2->intval()));
    }
  } else {
      return NumberClass->create_instance(Number::from_int(0));
  }
  return self;
}

FancyObject_p method_Number_minus(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  FancyObject_p arg = args.front();
  if(IS_NUM(arg->native_value())) {
    Number_p num1 = dynamic_cast<Number_p>(self->native_value());
    Number_p num2 = dynamic_cast<Number_p>(arg->native_value());
    if(num1->is_double() || num2->is_double()) {
      return NumberClass->create_instance(Number::from_double(num1->doubleval() - num2->doubleval()));
    } else {
      return NumberClass->create_instance(Number::from_int(num1->intval() - num2->intval()));
    }
  } else {
    return NumberClass->create_instance(Number::from_int(0));
  }
  return self;
}

FancyObject_p method_Number_multiply(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  FancyObject_p arg = args.front();
  if(IS_NUM(arg->native_value())) {
    Number_p num1 = dynamic_cast<Number_p>(self->native_value());
    Number_p num2 = dynamic_cast<Number_p>(arg->native_value());
    if(num1->is_double() || num2->is_double()) {
      return NumberClass->create_instance(Number::from_double(num1->doubleval() * num2->doubleval()));
    } else {
      return NumberClass->create_instance(Number::from_int(num1->intval() * num2->intval()));
    }
  } else {
    return NumberClass->create_instance(Number::from_int(0));
  }
  return self;
}

FancyObject_p method_Number_divide(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  FancyObject_p arg = args.front();
  if(IS_NUM(arg->native_value())) {
    Number_p num1 = dynamic_cast<Number_p>(self->native_value());
    Number_p num2 = dynamic_cast<Number_p>(arg->native_value());
    // always return double number for division
    return NumberClass->create_instance(Number::from_double(num1->doubleval() / num2->doubleval()));
  } else {
    return NumberClass->create_instance(Number::from_int(0));
  }
  return self;
}

FancyObject_p method_Number_lt(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  FancyObject_p arg = args.front();
  if(IS_NUM(arg->native_value())) {
    Number_p num1 = dynamic_cast<Number_p>(self->native_value());
    Number_p num2 = dynamic_cast<Number_p>(arg->native_value());
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
  FancyObject_p arg = args.front();
  if(IS_NUM(arg->native_value())) {
    Number_p num1 = dynamic_cast<Number_p>(self->native_value());
    Number_p num2 = dynamic_cast<Number_p>(arg->native_value());
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
  FancyObject_p arg = args.front();
  if(IS_NUM(arg->native_value())) {
    Number_p num1 = dynamic_cast<Number_p>(self->native_value());
    Number_p num2 = dynamic_cast<Number_p>(arg->native_value());
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
  FancyObject_p arg = args.front();
  if(IS_NUM(arg->native_value())) {
    Number_p num1 = dynamic_cast<Number_p>(self->native_value());
    Number_p num2 = dynamic_cast<Number_p>(arg->native_value());
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
  FancyObject_p arg = args.front();
  if(IS_NUM(arg->native_value())) {
    Number_p num1 = dynamic_cast<Number_p>(self->native_value());
    Number_p num2 = dynamic_cast<Number_p>(arg->native_value());
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
  FancyObject_p arg = args.front();
  if(IS_BLOCK(arg->native_value())) {
    Number_p num1 = dynamic_cast<Number_p>(self->native_value());
    Block_p block = dynamic_cast<Block_p>(arg->native_value());
    int val = num1->intval();
    for(int i = 0; i < val; i++) {
      block->call(self, list<FancyObject_p>(1, NumberClass->create_instance(Number::from_int(i))), scope);
    }
  } else {
    errorln("Number#times: expects Block object as parameter!");
  }
  return nil;
}
