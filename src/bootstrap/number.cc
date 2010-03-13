#include "includes.h"

void init_number_class()
{
  NumberClass->def_native_method(new NativeMethod("+", method_Number_plus, 1));
  NumberClass->def_native_method(new NativeMethod("-", method_Number_minus, 1));
  NumberClass->def_native_method(new NativeMethod("*", method_Number_multiply, 1));
  NumberClass->def_native_method(new NativeMethod("/", method_Number_divide, 1));
}

/**
 * Number instance methods
 */
FancyObject_p method_Number_plus(FancyObject_p self, list<Expression_p> args, Scope *scope)
{
  if(args.size() != 1) {
    errorln("Number#+ expects 1 argument!");
  } else {
    FancyObject_p arg = args.front()->eval(scope);
    if(IS_NUM(self->native_value()) && IS_NUM(arg->native_value())) {
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
  }
  return self;
}

FancyObject_p method_Number_minus(FancyObject_p self, list<Expression_p> args, Scope *scope)
{
  if(args.size() != 1) {
    errorln("Number#- expects 1 argument!");
  } else {
    FancyObject_p arg = args.front()->eval(scope);
    if(IS_NUM(self->native_value()) && IS_NUM(arg->native_value())) {
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
  }
  return self;
}

FancyObject_p method_Number_multiply(FancyObject_p self, list<Expression_p> args, Scope *scope)
{
  if(args.size() != 1) {
    errorln("Number#* expects 1 argument!");
  } else {
    FancyObject_p arg = args.front()->eval(scope);
    if(IS_NUM(self->native_value()) && IS_NUM(arg->native_value())) {
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
  }
  return self;
}

FancyObject_p method_Number_divide(FancyObject_p self, list<Expression_p> args, Scope *scope)
{
  if(args.size() != 1) {
    errorln("Number#/ expects 1 argument!");
  } else {
    FancyObject_p arg = args.front()->eval(scope);
    if(IS_NUM(self->native_value()) && IS_NUM(arg->native_value())) {
      Number_p num1 = dynamic_cast<Number_p>(self->native_value());
      Number_p num2 = dynamic_cast<Number_p>(arg->native_value());
      // always return double number for division
      return NumberClass->create_instance(Number::from_double(num1->doubleval() / num2->doubleval()));
    } else {
      return NumberClass->create_instance(Number::from_int(0));
    }
  }
  return self;
}
