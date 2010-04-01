#include "includes.h"

void init_class_class()
{
  ClassClass->def_method("define_method:with:", new NativeMethod("define_method:with:", method_Class_define_method__with, 2));
  ClassClass->def_method("define_class_method:with:", new NativeMethod("define_method:with:", method_Class_define_class_method__with, 2));
}


/**
 * Console instance methods
 */

FancyObject_p method_Class_define_method__with(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  FancyObject_p arg1 = args.front();
  args.pop_front();
  FancyObject_p arg2 = args.front();

  if(IS_STRING(arg1->native_value()) && IS_BLOCK(arg2->native_value())) {
    dynamic_cast<Class_p>(self)->def_method(dynamic_cast<String_p>(arg1->native_value())->value(), 
                                            dynamic_cast<Block_p>(arg2->native_value()));
    return t;
  } else {
    errorln("Class#define_method:with: expects String and Block arguments.");
    return nil;
  }
}

FancyObject_p method_Class_define_class_method__with(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  FancyObject_p arg1 = args.front();
  args.pop_front();
  FancyObject_p arg2 = args.front();

  if(IS_STRING(arg1->native_value()) && IS_BLOCK(arg2->native_value())) {
    dynamic_cast<Class_p>(self)->def_class_method(dynamic_cast<String_p>(arg1->native_value())->value(),
                                                  dynamic_cast<Block_p>(arg2->native_value()));
    return t;
  } else {
    errorln("Class#define_class_method:with: expects String and Block arguments.");
    return nil;
  }
}
